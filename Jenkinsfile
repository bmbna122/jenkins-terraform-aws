pipeline {
    agent any
    environment {
        AWS_ACCOUNT_ID = "697076423622"
        AWS_REGION = "us-east-1"
        IMAGE_REPO = "my-jenkins-app"
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        REPOSITORY_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"
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
                    sh "docker tag ${IMAGE_REPO}:${IMAGE_TAG} ${REPOSITORY_URI}/${IMAGE_REPO}:latest"
                    sh "docker tag ${IMAGE_REPO}:${IMAGE_TAG} ${REPOSITORY_URI}/${IMAGE_REPO}:${IMAGE_TAG}"
                }
            }
        }
        stage('Push to ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${REPOSITORY_URI}"
                    sh "docker push ${REPOSITORY_URI}/${IMAGE_REPO}:latest"
                    sh "docker push ${REPOSITORY_URI}/${IMAGE_REPO}:${IMAGE_TAG}"
                }
            }
        }
        stage('Deploy to kubernetes') {
            steps {
                script {
                    sh "minikube start --driver=docker"
                    sh """
                    kubectl delete secret ecr-secret || true
                    kubectl create secret docker-registry ecr-secret \
                        --docker-server=${REPOSITORY_URI} \
                        --docker-username=AWS \
                        --docker-password=$(aws ecr get-login-password --region ${AWS_REGION})
                    """
                    sh "kubectl apply -f deployment.yaml"

                    sh "kubectl rollout restart deployment/my-app-deployment"
                        
                }
            }
        }
     } 
}