package util

import org.gradle.api.Project
import org.gradle.api.logging.Logger

class GitUtil {
    companion object {

        fun getCurrentBranch(branchProperty: String?): String {
            return branchProperty ?: "master"
        }

        fun getGithubProtocol(protocolProperty: String?): String {
            return protocolProperty ?: "git"
        }

        fun cloneRepository(logger: Logger, repositoryUrl: String, branchName: String, dest: String) {
            ProcessUtil.executeCommand(logger,
                "git clone --depth=1 --single-branch --branch $branchName $repositoryUrl \"$dest\"",
                logOutput = true, throwErrorOnFailure = true)
        }

        fun toGithubUrl(repositoryName: String, protocol: String): String {
            val repo = Constants.githubRepository
            if (protocol == "git") {
                return "git@github.com:$repo/$repositoryName.git"
            } else {
                return "https://github.com/$repo/$repositoryName.git"
            }
        }
    }
}
