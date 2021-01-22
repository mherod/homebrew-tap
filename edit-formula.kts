#!/usr/bin/env kscript

val bottleName = "resharkercli"

val file = java.io.File("./Formula/$bottleName.rb")

val fileText = file.readText()
val before = fileText.substringBefore("bottle do").trim()
val after = fileText.substringAfter("bottle do").substringAfter("end").trim()

val existingBottles = file.readLines().filter { "sha256" in it }

val newBottles = java.io.File("./build/$bottleName-bottleout.txt").readLines().filter { "sha256" in it && it !in existingBottles }

val bottleVersion = java.io.File("./build/$bottleName-version.txt").readText().trim()

val rewrite = buildString {
    appendln(before)
    appendln()
    appendln("  bottle do")
    appendln("    root_url \"https://github.com/mherod/$bottleName/releases/download/$bottleVersion\"")
    appendln("    cellar :any_skip_relocation")
    existingBottles.forEach { appendln(it) }
    newBottles.forEach { appendln(it) }
    appendln("  end")
    appendln()
    append("  ")
    append(after)
}

println(rewrite)

file.writeText(rewrite)

