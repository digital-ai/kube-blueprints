import org.gradle.api.DefaultTask
import org.gradle.api.Project
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.TaskAction
import util.GitUtil
import util.HelmUtil
import java.io.File

open class GetHelmChartTask : DefaultTask() {
    companion object {
        const val NAME = "getHelmChart"
    }

    init {
        this.dependsOn(CleanChartsTask.NAME)
    }

    @Input
    var helmChartName: String? = null
    @Input
    var helmChartCli: String = "helm"

    @TaskAction
    fun launch() {
        project.logger.lifecycle("About to start UpdateConfigTask.")

        val repoName = helmChartName!!
        val destination = getClonedRepositoryDestination(project, repoName)
        val targetDir = Constants.getChartsTarget(project).absolutePath

        GitUtil.cloneRepository(
            project,
            GitUtil.toGithubUrl(repoName, GitUtil.getGithubProtocol(project)),
            GitUtil.getCurrentBranch(project),
            destination
        )

        HelmUtil.helmRepo(project, helmChartCli)
        HelmUtil.helmDeps(project, helmChartCli, destination)
        val packageName = HelmUtil.helmPackage(project, helmChartCli, destination, targetDir)
        File(targetDir).resolve("versions.yaml")
            .appendText("$helmChartName: $packageName")
    }

    fun getClonedRepositoryDestination(project: Project, repository: String): String {
        return Constants.getChartsBuild(project)
            .resolve(repository)
            .toPath()
            .toAbsolutePath()
            .toString()
    }
}
