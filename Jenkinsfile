pipeline {
    agent any

    environment {
        // REPLACE 'dockerhub-credentials' with your actual Jenkins Credentials ID for Docker Hub
        DOCKER_HUB_CREDENTIALS_ID = 'dckr_pat_q_SsVlvdSfp5xQz4nzFG4-uENro' 
        
        // REPLACE 'your_dockerhub_username' with your actual Docker Hub username
        DOCKER_IMAGE = 'hrushi242001/cicd-final-mst'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout code from the configured Git repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker Image: ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    // Build image and tag it with Jenkins Build Number
                    // Note: 'bat' is used for Windows Jenkins nodes. If your Jenkins runs on Linux, change 'bat' to 'sh'.
                    bat "docker build -t ${DOCKER_IMAGE}:${BUILD_NUMBER} ."
                    
                    // Also tag as latest
                    bat "docker tag ${DOCKER_IMAGE}:${BUILD_NUMBER} ${DOCKER_IMAGE}:latest"
                }
            }
        }

        stage('Push to Docker Hub') {
            steps {
                script {
                    // Use Jenkins credentials binding to securely login to Docker Hub
                    withCredentials([usernamePassword(credentialsId: env.DOCKER_HUB_CREDENTIALS_ID, passwordVariable: 'DOCKER_HUB_PASSWORD', usernameVariable: 'DOCKER_HUB_USERNAME')]) {
                        // Login
                        bat "echo %DOCKER_HUB_PASSWORD% | docker login -u %DOCKER_HUB_USERNAME% --password-stdin"
                        
                        // Push the build number tag
                        bat "docker push ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                        
                        // Push the latest tag
                        bat "docker push ${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }

        stage('Deploy/Run Container') {
            steps {
                script {
                    echo "Running image ${DOCKER_IMAGE}:${BUILD_NUMBER} on Port 8080"
                    
                    // Stop and remove any existing container running on port 8080 to prevent conflicts
                    // The '|| exit 0' ensures the pipeline doesn't fail if the container doesn't exist yet
                    bat "docker stop cicd-mst-container || exit 0"
                    bat "docker rm cicd-mst-container || exit 0"
                    
                    // Run the container on port 8080 (mapped to Nginx internal port 80)
                    bat "docker run -d -p 8080:80 --name cicd-mst-container ${DOCKER_IMAGE}:${BUILD_NUMBER}"
                    
                    echo "Application successfully deployed and running on http://localhost:8080"
                }
            }
        }
    }
    
    post {
        always {
            // Clean up: Logout from Docker Hub to maintain security
            bat "docker logout"
        }
    }
}
