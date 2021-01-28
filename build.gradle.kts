import java.io.FileOutputStream

val githubUsername = "mherod"

val formulaFileTree = fileTree("Formula")
val headFile = file("$rootDir/.git/HEAD")

val brewBottlePublishTask = task("brewBottlePublish") {
    group = "homebrew"
}

formulaFileTree.forEach { formulaFile ->
    val formulaName = formulaFile.nameWithoutExtension
    val capitalizedName = formulaName.capitalize()
    val originalFormulaText = formulaFile.readText()
    val originalFormulaLines = formulaFile.readLines()
    val formulaVersion = "\"(\\S+)\"".toRegex()
        .find(originalFormulaLines.first { it.contains("version", ignoreCase = true) })!!.groupValues.last()
    println("Configuring $formulaName $formulaVersion")
    val existingBottles = originalFormulaLines
        .filter { "sha256" in it && "=>" in it }
    val buildBottleTask = task<Exec>("brewInstallBuildBottle$capitalizedName") {
        group = "homebrew"
        brewBottlePublishTask.dependsOn(this)
        inputs.file(formulaFile)
        outputs.files(fileTree("/usr/local/Cellar/$formulaName/$formulaVersion"))
        outputs.upToDateWhen {
            file("/usr/local/Cellar/$formulaName/$formulaVersion/bin/$formulaName").exists()
        }
        commandLine(
            "brew",
            "install",
            "--build-bottle",
            formulaName
        )
    }
    val bottlesFileCollection: ConfigurableFileTree = fileTree(mapOf(
        "dir" to projectDir,
        "include" to "$formulaName*.bottle.tar.gz"
    ))
    val bottleTaskName = "brewBottle$capitalizedName"
    val uploadTaskName = "brewBottleUpload$capitalizedName"
    val bottleConsoleOut = file("${bottleTaskName}.log")
    val bottleTask = task<Exec>(bottleTaskName) {
        doFirst {
            bottlesFileCollection.files.forEach { it.delete() }
        }
        group = "homebrew"
        brewBottlePublishTask.dependsOn(this)
        dependsOn(buildBottleTask)
        mustRunAfter(buildBottleTask)
        commandLine("brew", "bottle", formulaName)
        standardOutput = FileOutputStream(bottleConsoleOut)
        inputs.file(formulaFile)
        inputs.files(fileTree("/usr/local/Cellar/$formulaName/$formulaVersion"))
        outputs.files(bottlesFileCollection)
        outputs.file(bottleConsoleOut)
        outputs.upToDateWhen {
            bottleConsoleOut.exists() && bottlesFileCollection.files.count() == 1
        }
        doLast {
            tasks.getByName<Exec>(uploadTaskName) {
                val bottleFile = bottlesFileCollection.singleFile
                val newName = bottleFile.name.replace("--", "-")
                val newNameFile = file(newName)
                val os = newName.substringBeforeLast(".bottle").substringBeforeLast('.')
                bottleFile.renameTo(newNameFile)
                onlyIf { os !in originalFormulaText }
                args(newNameFile)
            }
        }
    }
    val uploadTask = task<Exec>(uploadTaskName) {
        group = "homebrew"
        brewBottlePublishTask.dependsOn(this)
        dependsOn(buildBottleTask, bottleTask)
        commandLine(
            "gh",
            "release",
            "upload",
            "--repo",
            "$githubUsername/$formulaName",
            formulaVersion
        )
        val uploadConsoleOut = file("$uploadTaskName.log")
        standardOutput = FileOutputStream(bottleConsoleOut)
        inputs.file(bottleConsoleOut)
        inputs.file(formulaFile)
        inputs.files(bottleTask.outputs.files)
        outputs.file(uploadConsoleOut)
        outputs.upToDateWhen { uploadConsoleOut.exists() }
    }
    val editFormulaTaskName = "brewEditFormulaForNewBottle$capitalizedName"
    val editFormulaTask = task(editFormulaTaskName) {
        group = "homebrew"
        brewBottlePublishTask.dependsOn(this)
        dependsOn(buildBottleTask, bottleTask)
        mustRunAfter(buildBottleTask, bottleTask)
        inputs.files(bottleConsoleOut, formulaFile)
        outputs.file(formulaFile)
        onlyIf {
            originalFormulaText.let { originalFormula ->
                bottleConsoleOut.exists() && bottleConsoleOut.readLines()
                    .filter { "sha256" in it && it !in existingBottles }
                    .any { it.substringAfterLast(':') !in originalFormula }
            }
        }
        doLast {
            val fileText = formulaFile.readText()
            val before = fileText.substringBefore("bottle do").trim()
            val after = fileText.substringAfter("bottle do").substringAfter("end").trim()
            val newBottles = bottleConsoleOut.readLines()
                .filter { "sha256" in it && it !in existingBottles }
                .filter { it.substringAfterLast(':') !in fileText }
            if (newBottles.isNotEmpty()) {
                val rewrite = buildString {
                    appendln(before)
                    appendln()
                    appendln("  bottle do")
                    appendln("    root_url \"https://github.com/$githubUsername/$formulaName/releases/download/$formulaVersion\"")
                    appendln("    cellar :any_skip_relocation")
                    (existingBottles + newBottles)
                        .map { it.trim() }
                        .distinct()
                        .forEach {
                            appendln("    $it")
                        }
                    appendln("  end")
                    appendln()
                    appendln("  ${after.trim()}")
                }
                formulaFile.writeText(rewrite)
            }
        }
    }
    task("gitCommitFormulaUpdate$capitalizedName") {
        group = "homebrew"
        brewBottlePublishTask.dependsOn(this)
        inputs.files(formulaFileTree)
        inputs.file(headFile)
        outputs.file(headFile)
        dependsOn(bottleTask, editFormulaTask, uploadTask)
        mustRunAfter(bottleTask, editFormulaTask, uploadTask)
        doLast {
            val commitMessage =
                "[automated] " +
                        "Update Formula/${formulaName}.rb " +
                        "for ${bottlesFileCollection.singleFile.nameWithoutExtension}"
            runCommand("git", "add", "${formulaFile.relativeToOrSelf(rootDir)}")
            runCommand("git", "commit", "-m", commitMessage)
        }
    }
}

fun runCommand(vararg command: String): List<String> {
    return ProcessBuilder(*command)
        .start()
        .inputStream
        .bufferedReader()
        .readLines()
}
