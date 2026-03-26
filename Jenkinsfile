pipeline {

    agent any



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



        stage('Setup Node') {

            steps {

                sh '''bash -e <<'NVMSETUP'

set -e

export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then

  curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

fi

. "$NVM_DIR/nvm.sh"

nvm install 20

nvm use 20

node -v && npm -v

NVMSETUP

                '''

            }

        }



        stage('Install Dependencies') {

            steps {

                sh '''bash -e <<'NVMRUN'

set -e

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm use 20

npm ci

NVMRUN

                '''

            }

        }



        stage('Lint') {

            steps {

                sh '''bash -e <<'NVMRUN'

set -e

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm use 20

npm run lint

NVMRUN

                '''

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

                    sh '''bash -e <<'NVMRUN'

set -e

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm use 20

if [ -z "${SONAR_HOST_URL:-}" ]; then

  echo "ERROR: SONAR_HOST_URL is empty. In Jenkins: Manage Jenkins → Configure System → SonarQube servers, set Server URL to an address this agent can reach (not localhost if SonarQube runs elsewhere or Jenkins is in Docker)."

  exit 1

fi

npx --yes sonarqube-scanner -Dsonar.host.url="$SONAR_HOST_URL" -Dsonar.token="${SONAR_AUTH_TOKEN:-}"

NVMRUN

                    '''

                }

            }

        }



        stage('Build') {

            steps {

                sh '''bash -e <<'NVMRUN'

set -e

export NVM_DIR="$HOME/.nvm"

. "$NVM_DIR/nvm.sh"

nvm use 20

npm run build

NVMRUN

                '''

            }

        }



        stage('Docker Build') {

            when {

                expression { fileExists('Dockerfile') }

            }

            steps {

                script {

                    def hasDocker = sh(script: 'command -v docker >/dev/null 2>&1', returnStatus: true) == 0

                    if (!hasDocker) {

                        echo 'Docker not installed on this agent; skipping Docker Build.'

                        return

                    }

                    def imageName = "${env.JOB_NAME}:${env.BUILD_NUMBER}"

                    sh "docker build -t ${imageName} ."

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

            script {

                try {

                    deleteDir()

                } catch (err) {

                    echo "Cleanup skipped (no workspace context): ${err.message}"

                }

            }

        }

        success {

            echo '✅ Build successful'

            slackSend(

                color: 'good',

                message: "✅ ${env.JOB_NAME} #${env.BUILD_NUMBER} succeeded\n<${env.BUILD_URL}|Open build> • Branch: ${env.BRANCH_NAME ?: 'N/A'} • Image: ${env.IMAGE_NAME}:${env.IMAGE_TAG ?: 'n/a'}"

            )

        }

        failure {

            echo '❌ Build failed'

            slackSend(

                color: 'danger',

                message: "❌ ${env.JOB_NAME} #${env.BUILD_NUMBER} failed\n<${env.BUILD_URL}|Open build> • Branch: ${env.BRANCH_NAME ?: 'N/A'}"

            )

        }

        unstable {

            slackSend(

                color: 'warning',

                message: "⚠️ ${env.JOB_NAME} #${env.BUILD_NUMBER} is unstable\n<${env.BUILD_URL}|Open build>"

            )

        }

    }

}