#!groovy
@Library('jenkins-pipeline-libs@master')
import com.xebialabs.pipeline.utils.Branches

pipeline {
    agent none

    options {
        buildDiscarder(logRotator(numToKeepStr: '5', artifactDaysToKeepStr: '7', artifactNumToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        ansiColor('xterm')
    }

    environment {
        REPOSITORY_NAME = 'kube-blueprints'
        RELEASE_EXPLICIT = "${getCurrentVersion()}-${getBranch()}"
        LINUX_JDK_NAME = 'OpenJDK 17.0.2'
    }

    stages {
        stage('Build Kube Blueprints') {
            agent {
                node {
                    label 'xld && linux'
                }
            }

            tools {
                jdk env.LINUX_JDK_NAME
            }

            steps {
                checkout scm
                sh "./gradlew clean uploadArchives devSnapshot -x updateDocs -x test --info --stacktrace"
                script {
                    if (fileExists('build/version.dump') == true) {
                        currentVersion = readFile 'build/version.dump'
                        env.version = currentVersion
                    }
                }
                archiveArtifacts artifacts: 'build/distributions/xl-op-blueprints-*.zip', fingerprint: true
            }
        }
        stage('Scan Vulnerabilities') {
            agent {
                node {
                    label 'xld && linux'
                }
            }

            tools {
                jdk env.LINUX_JDK_NAME
            }

            steps {
                checkout scm
                sh "./scripts/image-operator-list.sh | ./scripts/scan-with-trivy.sh operator-${getBranch()}"
                archiveArtifacts artifacts: "build/scanResults/**/*.txt", fingerprint: true
            }
        }
    }
    post {
        success {
            script {
                slackSend color: "good", tokenCredentialId: "slack-token", message: "Kube Blueprints ${getBranch()} build *SUCCESS* - <${env.BUILD_URL}|click to open>", channel: 'team-apollo-internal'
            }
        }
        failure {
            script {
                slackSend color: "danger", tokenCredentialId: "slack-token", message: "Kube Blueprints ${getBranch()} build *FAILED* - <${env.BUILD_URL}|click to open>", channel: 'team-apollo-internal'
            }
        }
    }
}

def getCurrentVersion() {
    return '25.3.0'
}

def getBranch() {
    // on simple Jenkins pipeline job the BRANCH_NAME is not filled in, and we run it only on master
    return env.BRANCH_NAME ? env.BRANCH_NAME.toLowerCase() : 'master'
}
