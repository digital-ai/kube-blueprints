import org.gradle.api.DefaultTask
import org.gradle.api.Project
import org.gradle.api.tasks.Input
import org.gradle.api.tasks.TaskAction
import org.gradle.api.tasks.Internal
import org.gradle.api.file.ProjectLayout
import org.gradle.api.provider.Property
import util.GitUtil
import util.HelmUtil
import java.io.File
import javax.inject.Inject

abstract class GetHelmChartTask @Inject constructor(private val layout: ProjectLayout) : DefaultTask() {
    companion object {
        const val NAME = "getHelmChart"
    }

    init {
        this.dependsOn(CleanChartsTask.NAME)
    }

    @get:Input
    abstract val helmChartName: Property<String>

    @get:Input
    abstract val helmChartCli: Property<String>

    @get:Input
    abstract val gitProtocol: Property<String>

    @get:Input
    abstract val currentBranch: Property<String>

    @TaskAction
    fun launch() {
        logger.lifecycle("About to start UpdateConfigTask.")

        val repoName = helmChartName.get()
        val destination = getClonedRepositoryDestination(repoName)
        val targetDir = Constants.getChartsTarget(layout.buildDirectory).absolutePath

        GitUtil.cloneRepository(
            logger,
            GitUtil.toGithubUrl(repoName, gitProtocol.get() ?: "ssh"),
            currentBranch.get() ?: "master",
            destination
        )

        HelmUtil.helmRepo(logger, helmChartCli.get())
        HelmUtil.helmDeps(logger, helmChartCli.get(), destination)
        val packageName = HelmUtil.helmPackage(logger, helmChartCli.get(), destination, targetDir)
        File(targetDir).resolve("versions.yaml")
            .appendText("${helmChartName.get()}: $packageName")
    }

    fun getClonedRepositoryDestination(repository: String): String {
        return Constants.getChartsBuild(layout.buildDirectory)
            .resolve(repository)
            .toPath()
            .toAbsolutePath()
            .toString()
    }
}
