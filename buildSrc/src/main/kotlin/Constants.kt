import org.gradle.api.file.DirectoryProperty
import java.io.File
import java.nio.file.Path

class Constants {
    companion object {
        const val githubRepository = "digital-ai"
        const val buildChartsDestFolder = "buildCharts"
        const val targetChartsDestFolder = "charts"

        fun getChartsBuild(buildDirectory: DirectoryProperty): File {
            return buildDirectory.dir(buildChartsDestFolder).get().asFile

        }

        fun getChartsTarget(buildDirectory: DirectoryProperty): File {
            return buildDirectory.dir(targetChartsDestFolder).get().asFile
        }
    }
}
