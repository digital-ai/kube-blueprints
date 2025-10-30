package util

import org.gradle.api.Project
import org.gradle.api.logging.Logger
import java.lang.IllegalStateException

class HelmUtil {
    companion object {

        fun helmRepo(logger: Logger, helmChartCli: String) {
            ProcessUtil.executeCommand(logger,
                "\"$helmChartCli\" repo add bitnami-repo https://charts.bitnami.com/bitnami",
                logOutput = true, throwErrorOnFailure = true)
        }

        fun helmDeps(logger: Logger, helmChartCli: String, chartDir: String) {
            ProcessUtil.executeCommand(logger,
                "\"$helmChartCli\" dependency update \"$chartDir\"",
                logOutput = true, throwErrorOnFailure = true)
        }

        fun helmPackage(logger: Logger, helmChartCli: String, chartDir: String, targetDir: String): String {
            val result = ProcessUtil.executeCommand(logger,
                "\"$helmChartCli\" package \"$chartDir\" --destination \"$targetDir\"",
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
