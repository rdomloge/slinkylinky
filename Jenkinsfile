pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
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
                script {
                    // Extract version from POM file
                    env.VERSION = sh(
                        script: "mvn help:evaluate -Dexpression=project.version -q -DforceStdout",
                        returnStdout: true
                    ).trim()
                    echo "Extracted version from POM: ${env.VERSION}"
                }
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