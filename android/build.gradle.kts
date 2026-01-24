import com.android.build.gradle.LibraryExtension

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")

    if (name == "isar_flutter_libs" || name == "workmanager") {
        pluginManager.withPlugin("com.android.library") {
            extensions.configure<LibraryExtension>("android") {
                namespace = if (name == "isar_flutter_libs") {
                    "com.isar_flutter_libs"
                } else {
                    "com.fluttercommunity.workmanager"
                }
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
