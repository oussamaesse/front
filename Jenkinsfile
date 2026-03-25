pipeline {
    agent any

    environment {
        // define any environment variables here, e.g. REGISTRY_URL = 'registry.example.com'
        NODE_VERSION = '20'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
                // use npm ci to install exactly what's in package-lock.json
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            steps {
                // add your test command if you have tests
                // sh 'npm run test'
                echo 'No tests configured'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Docker Build') {
            when {
                expression { fileExists('Dockerfile') }
            }
            steps {
                script {
                    def imageName = "${env.JOB_NAME}:${env.BUILD_NUMBER}"
                    sh "docker build -t ${imageName} ."
                    // Optionally push to registry if credentials are configured
                    // sh "docker push ${imageName}"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy stage - implement your own deployment logic here'
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        success {
            echo 'Build succeeded'
        }
        failure {
            echo 'Build failed'
        }
    }
}
