pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-credentials' 
        DOCKER_IMAGE = 'hrushi242001/cicd-final-mst'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    bat "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                    bat "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDENTIALS_ID, passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                        bat "echo %DOCKER_HUB_PASSWORD% | docker login -u %DOCKER_HUB_USERNAME% --password-stdin"
                        bat "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        bat "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy/Run Container') {
            steps {
                script {
                    echo "Running image ${DOCKER_IMAGE}:${BUILD_NUMBER} on Port 8080"
                    bat "docker stop cicd-mst-container || exit 0"
                    bat "docker rm cicd-mst-container || exit 0"
                    bat "docker run -d -p 8080:80 --name cicd-mst-container ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    echo "Application successfully deployed and running on http://localhost:8080"
                }
            }
        }
    }
    
    post {
        always {
            bat "docker logout"
        }
    }
}
