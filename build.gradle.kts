fileTree("Formula").forEach { formulaFile ->
    val name = formulaFile.nameWithoutExtension
    val capitalizedName = name.capitalize()
    val formulaVersion =
        "\"(\\S+)\"".toRegex().find(formulaFile.readLines().first { "version" in it })!!.groupValues.last()
    println("Configuring $name $formulaVersion")
    val buildBottleTask = task<Exec>("brewInstallBuildBottle$capitalizedName") {
        group = "homebrew"
        inputs.file(formulaFile)
        commandLine("brew", "install", "--build-bottle", name)
    }
    val bottlesFileCollection: ConfigurableFileTree = fileTree(mapOf(
        "dir" to projectDir,
        "include" to "$name*.bottle.tar.gz"
    ))
    val bottleTaskName = "brewBottle$capitalizedName"
    val uploadTaskName = "brewBottleUpload$capitalizedName"
    val bottleTask = task<Exec>(bottleTaskName) {
        group = "homebrew"
        dependsOn(buildBottleTask)
        mustRunAfter(buildBottleTask)
        commandLine("brew", "bottle", name)
        inputs.file(formulaFile)
        outputs.files(bottlesFileCollection)
        doLast {
            tasks.getByName<Exec>(uploadTaskName) {
                val bottleFile = bottlesFileCollection.singleFile
                val newName = File(bottleFile.name.replace("--", "-"))
                bottleFile.renameTo(newName)
                args(newName)
            }
        }
    }
    val bottleUploadTask = task<Exec>(uploadTaskName) {
        group = "homebrew"
        dependsOn(bottleTask)
        mustRunAfter(bottleTask)
        // gh release upload --repo mherod/$1 $bottleVersion
        commandLine("gh", "release", "upload", "--repo", "mherod/$name", formulaVersion)
        inputs.files(bottleTask.outputs.files)
        doFirst {
            println("args: $args")
        }
    }
}
