pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "697076423622"
        AWS_REGION = "us-east-1"
        IMAGE_REPO = "my-jenkins-app"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${IMAGE_REPO}"
     }
     stages {
        stage('Checkout') {
            steps{
                checkout scm
            }
        }
        stage('Docker Build') {
            steps {
                script {
                    sh "sed -i 's/PIPELINE_BUILD_NUMBER/${env.BUILD_NUMBER}/g' index.html"
                    sh "docker build -t ${IMAGE_REPO}:${IMAGE_TAG} ."
                    sh "docker tag ${IMAGE_REPO}:${IMAGE_TAG} ${REPOSITORY_URL}/${IMAGE_REPO}:latest"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URL}"
                    sh "docker push ${REPOSITORY_URL}/${IMAGE_REPO}:latest"
                    sh "docker psuh ${REPOSITORY_URL}/${IMAGE_REPO}:${IMAGE_TAG}"
                }
            }
        }
     } 
}