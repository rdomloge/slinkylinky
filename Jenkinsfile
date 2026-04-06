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

        stage('Docker Login') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
                    }
                    sh "docker buildx create --use --name multiarch || true"
                }
            }
        }

        stage('Docker builds') {
            parallel {
                stage('Docker: frontend') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-adminwebsite:${env.VERSION} \
                            --push frontend
                        """
                    }
                }

                stage('Docker: linkservice') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-linkservice:${env.VERSION} \
                            --push linkservice
                        """
                    }
                }

                stage('Docker: stats') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-stats:${env.VERSION} \
                            --push stats
                        """
                    }
                }

                stage('Docker: audit') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-audit:${env.VERSION} \
                            --push audit
                        """
                    }
                }

                stage('Docker: supplierengagement') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-supplierengagement:${env.VERSION} \
                            --push supplierengagement
                        """
                    }
                }

                stage('Docker: woocommerce') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -t ${env.REPO}-woocommerce:${env.VERSION} \
                            --push woocommerce
                        """
                    }
                }

                stage('Docker: keycloak') {
                    steps {
                        sh """
                        docker buildx build \
                            --platform linux/amd64,linux/arm64 \
                            -f sl-k8s-scripts/Dockerfile-keycloak \
                            -t ${env.REPO}-keycloak:${env.VERSION} \
                            --push sl-k8s-scripts
                        """
                    }
                }
            }
        }
    }
}
