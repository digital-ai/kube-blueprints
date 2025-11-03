import org.gradle.api.DefaultTask
import org.gradle.api.tasks.TaskAction
import org.gradle.api.file.ProjectLayout
import javax.inject.Inject

open class CleanChartsTask @Inject constructor(private val layout: ProjectLayout) : DefaultTask() {

    companion object {
        const val NAME = "cleanCharts"
    }

    @TaskAction
    fun launch() {
        logger.lifecycle("About to start CleanCheckedOutProjectsTask.")
        Constants.getChartsBuild(layout.buildDirectory)
            .deleteRecursively()
        Constants.getChartsTarget(layout.buildDirectory)
            .deleteRecursively()
    }
}
