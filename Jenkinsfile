pipeline {
    agent any
    stages {
        stage('Deploy') {
            steps {
                sh "rsync -av --delete --exclude='.git' --exclude='Jenkinsfile' ./ /var/www/html/"
            }
        }
    }
    post {
        success { echo 'Website deployed successfully' }
        failure { echo 'Deployment failed' }
    }
}
