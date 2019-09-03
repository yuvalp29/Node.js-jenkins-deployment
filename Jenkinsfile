pipeline {
    agent any
    stages {
                stage('Checkout'){
            checkout scm
        }   
        stage('Preparation') {
            steps {
                bitbucketStatusNotify buildState: "INPROGRESS"
            }
        } 
        stage('Build') {
            steps {
                sh "docker-composer build"
                sh "docker-compose up -d"
                waitUntilServicesReady
            }
        }
        stage('Runing Tests') {
            steps {
                sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
                sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction behat-ci"
            }
        }
        stage ('Cleanup') {
            sh "echo cleanup starting..."
            sh "docker image prune -af"
            sh "echo cleanup finished."
            
            mail body: 'project build successful',
                 from: 'ypodoksik29@gmail.com',
                 subject: 'project build successful',
                 to: 'ypodoksik29@gmail.com'
        }
    }
    post {
        always {
            echo 'This will always run'
        }
        success {
            echo 'This will run only if successful'
        }
        failure {
            echo 'This will run only if failed'
        }
        unstable {
            echo 'This will run only if the run was marked as unstable'
        }
        changed {
            echo 'This will run only if the state of the Pipeline has changed'
            echo 'For example, if the Pipeline was previously failing but is now successful'
        }
    }
}
