pipeline {

    agent { label "maven-worker" }

    environment {
        VERSION = "${SEMVER_BUILD_NUM}-CI-${env.BUILD_ID}"
        REPO    = 'rdomloge/slinky-linky'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/slinkylinky.git"
                }
            }
        }

        stage('Build Maven Modules') {
            steps {
                sh 'mvn -Dmaven.test.skip=true clean install'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Tag and Release') {
            steps {
                script {
                    withFolderProperties() {
                        sh "git config user.email 'you@example.com'"
                        sh "git config user.name 'Your Name'"
                        sh "git tag -a ${env.VERSION} -m 'Jenkins CI automated tag'"
                        sh "git push https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/slinkylinky.git ${env.VERSION}"
                    }
                }
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
                        sh "docker buildx create --use --name multiarch || true"

                        // linkservice
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-linkservice:${env.VERSION} \
                            --push linkservice
                        """

                        // stats
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-stats:${env.VERSION} \
                            --push stats
                        """

                        // audit
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-audit:${env.VERSION} \
                            --push audit
                        """

                        // supplierengagement
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-supplierengagement:${env.VERSION} \
                            --push supplierengagement
                        """

                        // woocommerce
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-woocommerce:${env.VERSION} \
                            --push woocommerce
                        """

                        // frontend (build context is frontend/, Dockerfile is frontend/Dockerfile)
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-adminwebsite:${env.VERSION} \
                            --push frontend
                        """
                    }
                }
            }
        }
    }
}
