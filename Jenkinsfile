pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
        VERSION = "${SEMVER_BUILD_NUM}"
        PROJECT = 'events'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/${env.PROJECT}.git"
                }
            }
        }
        stage('Build Maven Project') {
            steps {
                sh 'mvn -Dmaven.test.skip=true clean package'
            }
        }

        stage('Tag and Release') {
            steps {
                script {
                    withFolderProperties() {
                        // Create Git tag
                        sh "echo 'Tagging with ${env.VERSION}'"

                        sh "git config user.email 'you@example.com'"
                        sh "git config user.name 'Your Name'"

                        sh "git tag -a ${env.VERSION} -m 'Jenkins CI automated tag'"
                        sh "git push https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/${env.PROJECT}.git ${env.VERSION}"
                    }
                }
            }
        }
    }
}