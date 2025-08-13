pipeline {
  agent {
    docker {
      image 'node:20-alpine'
    }
  }

  environment {
    CI = 'true'
  }

  stages {

    stage('Checkout') {
      steps {
        // pulls the source code from Git
        checkout scm
      }
    }
    stage('Install') {
      steps {
        sh '''
          mkdir -p /tmp/.npm
          NPM_CONFIG_CACHE=/tmp/.npm npm ci
        '''
      }
    }

    stage('Lint') {
      steps {
        sh 'npm run lint'
      }
    }

    stage('Test') {
      steps {
        sh 'npm run test'
      }
    }

    stage('Build Frontend') {
      steps {
        sh 'npm run build'
      }
    }

    post {
    success {
      // Trigger next job to build + push Docker image
      build job: 'docker-build-push-tic-tac', wait: true
      }
    }
  }
}
