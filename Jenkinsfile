pipeline {
    agent any

    environment {
        NODE_VERSION = '20'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            agent {
                docker { image "node:${env.NODE_VERSION}" }
            }
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            agent {
                docker { image "node:${env.NODE_VERSION}" }
            }
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            agent {
                docker { image "node:${env.NODE_VERSION}" }
            }
            steps {
                echo 'No tests configured'
                // sh 'npm run test'  // Décommenter si vous avez des tests
            }
        }

        stage('Build') {
            agent {
                docker { image "node:${env.NODE_VERSION}" }
            }
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
                    // Optionnel : sh "docker push ${imageName}"
                }
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploy stage - implémentez votre logique de déploiement ici'
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