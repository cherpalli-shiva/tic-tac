pipeline {
    agent any

    triggers {
        pollSCM('H/1 * * * *')  // Poll GitHub every minute; replace with webhook for better performance
    }

    stages {
        stage('Checkout') {
            steps {
                // Change URL and credentials as needed
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/cherpalli-shiva/tic-tac.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Hardcoded Docker image name with build number tag
                    dockerImage = docker.build("cherpalli/tic-tac-toe:${env.BUILD_NUMBER}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('', 'dockerhub-credentials') {
                        dockerImage.push()
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Update Kubernetes Manifest') {
            steps {
                script {
                    // Hardcoded manifest file path and sed command to update image tag
                    sh """
                    sed -i 's|image: .*|image: cherpalli/tic-tac-toe:${BUILD_NUMBER}|' k8s/deployment.yaml
                    """
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    // Apply the updated k8s manifest
                    sh "kubectl apply -f k8s/deployment.yaml"
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
