package util

import org.gradle.api.Project
import java.lang.IllegalStateException

class HelmUtil {
    companion object {

        fun helmRepo(project: Project, helmChartCli: String) {
            ProcessUtil.executeCommand(project,
                "$helmChartCli repo add bitnami-repo https://charts.bitnami.com/bitnami",
                logOutput = true, throwErrorOnFailure = true)
        }

        fun helmDeps(project: Project, helmChartCli: String, chartDir: String) {
            ProcessUtil.executeCommand(project,
                "$helmChartCli dependency update \"$chartDir\"",
                logOutput = true, throwErrorOnFailure = true)
        }

        fun helmPackage(project: Project, helmChartCli: String, chartDir: String, targetDir: String): String {
            val result = ProcessUtil.executeCommand(project,
                "$helmChartCli package \"$chartDir\" --destination \"$targetDir\"",
                logOutput = true, throwErrorOnFailure = true)
            val version = result.substringAfterLast("$targetDir/runner-", "")
                .substringBefore(".tgz", "")
            if (version == "") {
                throw IllegalStateException("Cannot get version from package output")
            }
            return "runner-$version.tgz"
        }
    }
}
