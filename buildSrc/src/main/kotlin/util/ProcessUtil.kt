package util

import org.apache.tools.ant.taskdefs.condition.Os
import org.gradle.api.Project
import org.gradle.api.logging.Logger
import java.io.BufferedReader
import java.io.File
import java.io.InputStreamReader
import java.util.concurrent.TimeUnit

class ProcessUtil {
    companion object {
        private fun createRunCommand(baseCommand: String, runLocalShell: Boolean): MutableList<String> {
            return if (runLocalShell) {
                if (Os.isFamily(Os.FAMILY_WINDOWS)) {
                    mutableListOf("cmd", "/c", "${baseCommand}.cmd")
                } else {
                    mutableListOf("./${baseCommand}.sh")
                }
            } else {
                mutableListOf(baseCommand)
            }
        }

        @Suppress("UNCHECKED_CAST")
        fun exec(config: Map<String, Any?>): Process {

            val runLocalShell = config.getOrDefault("runLocalShell", true) as Boolean
            val command = createRunCommand(config["command"] as String, runLocalShell)

            if (config["params"] != null) {
                command.addAll(config["params"] as List<String>)
            }

            val processBuilder = ProcessBuilder(command)
            if (config["environment"] != null) {
                processBuilder.environment().putAll(config["environment"] as Map<String, String>)
            }

            if (config["workDir"] != null) {
                processBuilder.directory(config["workDir"] as File)
            }

            if (config["inheritIO"] != null) {
                processBuilder.inheritIO()
            }

            if (config["discardIO"] != null) {
                processBuilder.redirectOutput(ProcessBuilder.Redirect.DISCARD)
                processBuilder.redirectError(ProcessBuilder.Redirect.DISCARD)
            }

            if (config["redirectTo"] != null) {
                processBuilder.redirectErrorStream(true)
                val redirectTo = config["redirectTo"] as File
                if (!redirectTo.parentFile.isDirectory) {
                    redirectTo.parentFile.mkdirs()
                }
                processBuilder.redirectOutput(ProcessBuilder.Redirect.to(redirectTo))
            }

            val process = processBuilder.start()
            if (config["wait"] != null) {
                process.waitFor()
            }

            return process
        }

        fun executeCommand(
            command: String,
            workDir: File? = null,
            logOutput: Boolean = true,
            throwErrorOnFailure: Boolean = true,
            waitTimeoutSeconds: Long = 10
        ): String {
            return executeCommand(null, command, workDir, logOutput, throwErrorOnFailure, waitTimeoutSeconds)
        }

        fun executeCommand(
            logger: Logger?,
            command: String,
            workDir: File? = null,
            logOutput: Boolean = true,
            throwErrorOnFailure: Boolean = true,
            waitTimeoutSeconds: Long = 10
        ): String {
            fun print(msg: String, error: Boolean = false) {
                if (logger != null && msg.isNotEmpty() && logOutput) {
                    if (error) {
                        logger.error(msg)
                    } else {
                        logger.lifecycle(msg)
                    }
                }
            }

            val execCommand = arrayOf("sh", "-c", command)
            val process: Process =
                if (workDir != null)
                    Runtime.getRuntime().exec(execCommand, null, workDir)
                else
                    Runtime.getRuntime().exec(execCommand)

            val stdInput = BufferedReader(InputStreamReader(process.inputStream))
            val stdError = BufferedReader(InputStreamReader(process.errorStream))

            if (workDir == null) {
                print("About to execute `$command`")
            } else {
                print("About to execute `$command` in work dir `${workDir.absolutePath}`")
            }

            val input = readLines(stdInput) { line -> print(line) }
            val error = readLines(stdError) { line -> print(line, true) }

            if (process.waitFor(waitTimeoutSeconds, TimeUnit.SECONDS)) {
                if (throwErrorOnFailure && process.exitValue() != 0) {
                    throw RuntimeException("Process '$command' failed with exit value ${process.exitValue()}: $error")
                }
            } else if (throwErrorOnFailure) {
                throw RuntimeException("Process '$command' not finished")
            }

            return if (error == "") {
                input
            } else {
                input + System.lineSeparator() + error
            }
        }

        private fun readLines(reader: BufferedReader, lineHandler: (String) -> Unit): String {
            var result = ""
            var line = ""
            while (reader.readLine().also { if (it != null) line = it } != null) {
                line.also {
                    if (result != "")
                        result += System.lineSeparator()
                    result += it
                }
                lineHandler(line)
            }
            return result
        }
    }
}
