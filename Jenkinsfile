pipeline {
    agent { label 'Jenkins-Agent' }
    tools {
        maven 'Maven03'
        jdk 'Java21'
    }

    environment {
        APP_NAME = 'register-app-pipeline'
        RELEASE = '1.0.0'
        DOCKER_USER = 'remson001'
        DOCKER_PASS = 'Dockerhub'
        IMAGE_NAME = "${DOCKER_USER}/${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
    }

    stages {
        stage ('clean workspace') {
            steps {
                cleanWs()
            }
        }

        stage ('checkout from SCM') {
            steps {
                git  branch: 'main', credentialsId: 'GitHub', url: 'https://github.com/RAM12837/register-app'
            }
        }

        stage ('Build Application') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage ('Test Application') {
            steps {
                sh 'mvn test'
            }
        } 

        stage('Sonarqube Analysis') {
            steps {
                script {
                    withSonarQubeEnv(credentialsId: 'Jenkins-Sonarqube-token') {
                        sh 'mvn sonar:sonar'
                    }
                }
            }
        }

        stage ('Quality Gate') {
            steps {
                script {
                    waitForQualityGate(credentialsId: 'Jenkins-Sonarqube-token')
                }
            }
        }

        stage ('Build Docker Image') {
            steps {
                script {
                    docker_image = docker.build("${IMAGE_NAME}:${IMAGE_TAG}")
                }
            }
        }

        stage ('trivy scan') {
            steps {
                script {
                    sh '''
                    docker run --rm \
                    -v /var/run/docker.sock:/var/run/docker.sock \
                    aquasec/trivy image \
                    ${IMAGE_NAME}:${IMAGE_TAG} \
                    --no-progress \
                    --scanners vuln \
                    --exit-code 0 \
                    --severity HIGH,CRITICAL \
                    --format table
                    '''
                }
            }
        }

        stage ('push docker image') {
            steps {
                script {
                    docker.withRegistry('', DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }

        stage ('cleanup artifacts') {
            steps {
                script {
                    sh "docker rmi ${IMAGE_NAME}:${IMAGE_TAG} || true"
                    sh "docker rmi ${IMAGE_NAME}:latest || true"

                    sh '''
                    docker container prune -f || true
                    docker image prune -af || true
                    '''
                }
            }
        }

        stage ('trigger CD pipeline') {
            steps {
                script {
                    build job: 'gitops-register-app-cd',
                    wait: false,
                    parameters: [
                        string(
                            name: 'IMAGE_TAG',
                            value: "${IMAGE_TAG}"
                        )
                    ]
                }
            }
        }
    }  
}
