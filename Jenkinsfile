pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/events.git"
                }
            }
        }
        stage('Build Maven Project') {
            steps {
                sh 'mvn -Dmaven.test.skip=true clean install'
            }
        }
    }
    // post {
    //     always {
    //         cleanWs()
    //     }
    // }
}