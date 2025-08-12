pipeline {
    agent any

    stages {
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
        stage('Checkout from git') {
            steps {
                git branch: 'main', credentialsId: 'github-credentials', url: 'https://github.com/cherpalli-shiva/tic-tac.git'
            }
        }
        stage('Build and Test') {
            steps {
                sh '''
                npm ci
                npm run test
                npm run build
                '''
            }
        }
    }
}
