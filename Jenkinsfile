pipeline {
    
    agent { label "kubectl-worker" }

    environment {
        BUILDER = 'mybuilder'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/adminwebsite.git"
                }
            }
        }
        stage('Build image') {
            steps {
                /* This builds the actual image; synonymous to
                * docker build on the command line */
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        // Use the Dockerfile in the root of the repository

                        def image = docker.image("rdomloge/slinky-linky-adminwebsite:${SEMVER_BUILD_NUM}-CI-${env.BUILD_ID}")
                        sh "docker buildx create --use --name multiarch"
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${image.imageName()} \
                            --push .
                        """
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