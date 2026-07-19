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

        stage ('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}:${IMAGE_TAG}"
                    }

                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        } 
    }
    
}
