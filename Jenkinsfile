pipeline {
    
    agent { label "maven-worker" }

    environment {
        IMAGE_NAME = 'rdomloge/slinky-linky-linkservice:5.10.0'
        BUILDER = 'mybuilder'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: "https://banana@github.com/rdomloge/linkservice.git"
            }
        }
        stage('Build Maven Project') {
            steps {
                sh 'mvn -Dmaven.test.skip=true clean package'
            }
        }
        stage('Build image') {
            steps {
                /* This builds the actual image; synonymous to
                * docker build on the command line */
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                        // Use the Dockerfile in the root of the repository
                        def newApp = docker.build("rdomloge/slinky-linky-linkservice:${env.BUILD_ID}")
                        newApp.push()
                    }
                }
            }
        }
        
    }
    // post {
    //     always {
    //         cleanWs()
    //     }
    // }
}