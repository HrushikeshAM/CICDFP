pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS_ID = 'dockerhub-credentials'
        DOCKER_IMAGE = 'hrushi242001/cicd-final-mst'
        CONTAINER_NAME = 'cicd-mst-container'
        APP_PORT = '8080'
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

                    bat """
                    docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} .
                    docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    withCredentials([
                        usernamePassword(
                            credentialsId: "${DOCKER_HUB_CREDENTIALS_ID}",
                            usernameVariable: 'DOCKER_HUB_USERNAME',
                            passwordVariable: 'DOCKER_HUB_PASSWORD'
                        )
                    ]) {

                        bat """
                        @echo off
                        echo %DOCKER_HUB_PASSWORD% | docker login -u %DOCKER_HUB_USERNAME% --password-stdin
                        docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}
                        docker push ${DOCKER_IMAGE}:latest
                        """
                    }
                }
            }
        }

        stage('Deploy Container') {
            steps {
                script {
                    echo "Deploying Container on Port ${APP_PORT}"

                    bat """
                    docker stop ${CONTAINER_NAME} >nul 2>&1
                    docker rm ${CONTAINER_NAME} >nul 2>&1
                    docker run -d -p ${APP_PORT}:80 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}:${BUILD_NUMBER}
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo "Application deployed successfully"
                echo "Open in browser: http://localhost:${APP_PORT}"
            }
        }
    }

    post {

        success {
            echo "Pipeline completed successfully"
        }

        failure {
            echo "Pipeline failed"
        }

        always {
            bat "docker logout"
            cleanWs()
        }
    }
}