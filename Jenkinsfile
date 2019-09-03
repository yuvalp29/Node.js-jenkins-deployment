pipeline {
    agent { docker { image 'node:6.3' } }
    stages {
        stage('Checkout'){
            checkout scm
        }
        stage("Preparation") {
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
        stage("Runing Tests") {
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
}
