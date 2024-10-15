#!groovy
@Library('jenkins-pipeline-libs@master')
import com.xebialabs.pipeline.utils.Branches

pipeline {
    agent none

    options {
        buildDiscarder(logRotator(numToKeepStr: '20', artifactDaysToKeepStr: '7', artifactNumToKeepStr: '5'))
        timeout(time: 1, unit: 'HOURS')
        timestamps()
        ansiColor('xterm')
    }

    environment {
        REPOSITORY_NAME = 'kube-blueprints'
        RELEASE_EXPLICIT = "25.1.0-${getBranch()}"
        LINUX_JDK_NAME = 'OpenJDK 17.0.2'
    }

    stages {
        stage('Build Kube Blueprints') {
            parallel {
                stage('Build Kube Blueprints') {
                    agent {
                        node {
                            label 'xld'
                        }
                    }

                    tools {
                        jdk env.LINUX_JDK_NAME
                    }

                    steps {
                        checkout scm
                        sh "./gradlew clean uploadArchives devSnapshot -x updateDocs -x test --info"
                        script {
                            if (fileExists('build/version.dump') == true) {
                                currentVersion = readFile 'build/version.dump'
                                env.version = currentVersion
                            }
                        }
                        archiveArtifacts artifacts: 'build/distributions/xl-op-blueprints-*', fingerprint: true
                    }
                }
            }
        }
    }
    post {
        success {
            script {
                if (env.BRANCH_NAME == 'master') {
                    slackSend color: "good", tokenCredentialId: "slack-token", message: "Kube Blueprints master build *SUCCESS* - <${env.BUILD_URL}|click to open>", channel: 'team-apollo'
                }
            }
        }
        failure {
            script {
                if (env.BRANCH_NAME == 'master') {
                    slackSend color: "danger", tokenCredentialId: "slack-token", message: "Kube Blueprints master build *FAILED* - <${env.BUILD_URL}|click to open>", channel: 'team-apollo'
                }
            }
        }
    }
}

def getBranch() {
    // on simple Jenkins pipeline job the BRANCH_NAME is not filled in, and we run it only on master
    return env.BRANCH_NAME ?: 'master'
}
