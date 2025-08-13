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
      mkdir -p /home/jenkins/.npm
      npm config set cache /home/jenkins/.npm
      npm ci
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

    stage('Docker Build') {
      steps {
        script {
          def tag = "vite-react-app:${env.BUILD_NUMBER}"
          sh "docker build -t ${tag} ."
        }
      }
    }

    stage('Docker Push') {
      steps {
        withCredentials([string(credentialsId: 'dockerhub-credentials', variable: 'DOCKER_PASS')]) {
          script {
            sh '''
              echo "$DOCKER_PASS" | docker login -u cherpalli --password-stdin
              docker tag vite-react-app:${BUILD_NUMBER} cherpalli/vite-react-app:${BUILD_NUMBER}
              docker push cherpalli/vite-react-app:${BUILD_NUMBER}
            '''
          }
        }
      }
    }
  }
}