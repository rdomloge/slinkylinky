pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
        VERSION = "${SEMVER_BUILD_NUM}-CI-${env.BUILD_ID}"
        PROJECT = 'linkservice'
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/${env.PROJECT}.git"
                    
                }
            }
        }
        
        stage('Build Events Dependency') {
            steps {
                script {
                    withFolderProperties() {
                        // Extract events version from pom.xml - simplified approach
                        def eventsVersion = sh(
                            script: "grep -A 1 '<artifactId>events</artifactId>' pom.xml | grep '<version>' | sed 's/.*<version>\\(.*\\)<\\/version>.*/\\1/' | tr -d '[:space:]'",
                            returnStdout: true
                        ).trim()
                        
                        if (!eventsVersion) {
                            eventsVersion = '6.1.0' // fallback to current known version
                        }
                        
                        echo "Building events dependency version: ${eventsVersion}"
                        
                        // Create a temporary directory for events
                        sh 'mkdir -p temp-events'
                        dir('temp-events') {
                            // Checkout events repository at the specific tag
                            checkout([
                                $class: 'GitSCM',
                                branches: [[name: "refs/tags/${eventsVersion}"]],
                                userRemoteConfigs: [[
                                    url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/events.git"
                                ]]
                            ])
                            
                            // Build and install events to local Maven repository
                            sh 'mvn clean install -DskipTests'
                        }
                        
                        // Clean up temp directory
                        sh 'rm -rf temp-events'
                    }
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