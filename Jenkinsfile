pipeline {
    agent any

    environment {
        DOCKER_IMAGE = "chaitanyaaaa/devops-app"
        TAG = "v1.${BUILD_NUMBER}"
        AWS_DEFAULT_REGION = "us-east-1"
    }

    stages {

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $DOCKER_IMAGE:$TAG .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'DockerHub-Creds',
                    usernameVariable: 'USER',
                    passwordVariable: 'PASS'
                )]) {
                    sh 'echo $PASS | docker login -u $USER --password-stdin'
                    sh 'docker push $DOCKER_IMAGE:$TAG'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'cd environments/dev && terraform init'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh 'cd environments/dev && terraform apply -auto-approve'
                }
            }
        }

        stage('Deploy to EC2 via SSM') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-creds'
                ]]) {
                    sh '''
                    aws ssm send-command \
                    --document-name "AWS-RunShellScript" \
                    --targets "Key=tag:Name,Values=app-instance" \
                    --parameters 'commands=[
                        "docker pull chaitanyaaaa/devops-app:'"${TAG}"'",
                        "docker stop $(docker ps -q) || true",
                        "docker run -d -p 80:3000 chaitanyaaaa/devops-app:'"${TAG}"'"
                    ]'
                    '''
                }
            }
        }
    }
}
