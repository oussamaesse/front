pipeline {
    agent any

    // Puts `node` and `npm` on PATH. Name must match Jenkins → Manage Jenkins → Tools → NodeJS
    // (add Node 20.x from nodejs.org if needed). Rename 'NodeJS-20' here to match your installation label.
    tools {
        nodejs 'NodeJS-20'
    }

    environment {
        NODE_VERSION = '20'
        SONARQUBE_INSTALLATION = 'sonar_cube'
    }


    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Install Dependencies') {
            steps {
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
                echo 'No tests configured'
            }
        }

 stage('SonarQube analysis') {
            steps {
                withSonarQubeEnv("${env.SONARQUBE_INSTALLATION}") {
                    sh '''
                        set -e
                        if [ -z "${SONAR_HOST_URL:-}" ]; then
                          echo "ERROR: SONAR_HOST_URL is empty. In Jenkins: Manage Jenkins → Configure System → SonarQube servers, set Server URL to an address this agent can reach (not localhost if SonarQube runs elsewhere or Jenkins is in Docker)."
                          exit 1
                        fi
                        npx --yes sonarqube-scanner \
                          -Dsonar.host.url="$SONAR_HOST_URL" \
                          -Dsonar.token="${SONAR_AUTH_TOKEN:-}"
                    '''
                }
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
            echo '🧹 cleaning up the workspace...'
            deleteDir()
        }
        success {
            echo '✅ Build successful'
            slackSend(
                color: 'good',
                message: "✅ *${env.JOB_NAME}* #${env.BUILD_NUMBER} succeeded\n<${env.BUILD_URL}|Open build> • Branch: ${env.BRANCH_NAME ?: 'N/A'} • Image: `${env.IMAGE_NAME}:${env.IMAGE_TAG ?: 'n/a'}`"
            )
        }
        failure {
            echo '❌ Build failed'
            slackSend(
                color: 'danger',
                message: "❌ *${env.JOB_NAME}* #${env.BUILD_NUMBER} failed\n<${env.BUILD_URL}|Open build> • Branch: ${env.BRANCH_NAME ?: 'N/A'}"
            )
        }
        unstable {
            slackSend(
                color: 'warning',
                message: "⚠️ *${env.JOB_NAME}* #${env.BUILD_NUMBER} is unstable\n<${env.BUILD_URL}|Open build>"
            )
        }
    }
}