pipeline {
    
    agent { label "maven-worker" }

    environment {
        BUILDER = 'mybuilder'
        VERSION = "${SEMVER_BUILD_NUM}-CI-${env.BUILD_ID}"
    }

    stages {
        stage('Checkout') {
            steps {
                withFolderProperties() {
                    git branch: 'main', url: "https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/linkservice.git"
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
                        def tagName = "${env.VERSION}"
                        sh "echo 'Tagging with ${tagName}'"

                        git tag ${tagName} -m 'Jenkins CI automated tag'

                        // sh "git tag -a ${tagName} -m 'Release test'"
                        // sh "git push https://${env.GITHUB_PERSONAL_ACCESS_TOKEN}@github.com/rdomloge/linkservice.git ${tagName}"
                        
                        // // Create GitHub release (optional)
                        // withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                        //     sh """
                        //     curl -X POST \
                        //         -H "Authorization: token ${GITHUB_TOKEN}" \
                        //         -H "Accept: application/vnd.github.v3+json" \
                        //         https://api.github.com/repos/rdomloge/linkservice/releases \
                        //         -d '{
                        //             "tag_name": "${tagName}",
                        //             "target_commitish": "main",
                        //             "name": "Release ${tagName}",
                        //             "body": "Automated release from Jenkins build #${env.BUILD_ID}",
                        //             "draft": false,
                        //             "prerelease": false
                        //         }'
                        //     """
                        // }
                    }
                }
            }
        }
        
        // stage('Build image') {
        //     steps {
        //         /* This builds the actual image; synonymous to
        //         * docker build on the command line */
        //         script {
        //             docker.withRegistry('https://registry.hub.docker.com', 'docker-hub-credentials') {
        //                 // Use the Dockerfile in the root of the repository
        //                 def image = docker.image("rdomloge/slinky-linky-linkservice:${env.VERSION}")
        //                 sh "docker buildx create --use --name multiarch"
        //                 sh """
        //                 docker buildx build \
        //                     --platform linux/amd64,linux/arm64 \
        //                     -t ${image.imageName()} \
        //                     --push .
        //                 """
        //             }
        //         }
        //     }
        // }
        
        
        
    }
}