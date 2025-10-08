pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
        VERSION = "${SEMVER_BUILD_NUM}-CI-${env.BUILD_ID}"
        PROJECT = 'adminwebsite'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/${env.PROJECT}.git"
                }
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
        
        stage('Build image') {
            steps {
                /* This builds the actual image; synonymous to
                * docker build on the command line */
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        // Use the Dockerfile in the root of the repository
                        def image = docker.image("rdomloge/slinky-linky-${env.PROJECT}:${env.VERSION}")
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
}