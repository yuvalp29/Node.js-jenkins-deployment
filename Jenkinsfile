pipeline {
    agent {
        docker {
            image 'node:6-alpine'
            args '-p 3000:3000 -p 5000:5000'
        }
    }
    environment {
        CI = 'true'
    }
    stages {
        stage('Prepare') {
            steps {
                sh "echo Preparation stage is runing."
                checkout scm    
                sh "echo Preparation stage completed."
            }
        }
        stage('Build') {
            steps {
                sh "echo Build stage is runing."
                //sh "docker-composer build"
                //sh "docker-compose up -d"
                //waitUntilServicesReady
                sh "echo Build stage completed."
            }
        }
        stage('Test') {
            steps {
                sh "echo Test stage is runing."
                //sh './test.sh'
                //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
                //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction behat-ci"
                sh "echo Test stage completed."
            }
        }
        stage('Deliver for development') {
            when {
                branch 'development' 
            }
            steps {
                //sh './deliver-for-development.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "echo Deliver for development stage is runing."
                //sh './kill.sh'
                sh "echo Application deliverd to development. Deliver stage completed."   
            }
        }
        stage('Deploy for production') {
            when {
                branch 'production'  
            }
            steps {
                //sh './deploy-for-production.sh'
                input message: 'Finished using the web site? (Click "Proceed" to continue)'
                sh "echo Deploy for production stage is runing."
                //sh './kill.sh'
                sh "echo Application lunched on production. Deploy stage completed."   
            }
        }
        stage('Cleanup') {
            steps {
                sh "echo Cleanup stage is runing."
                //sh "docker image prune -af"
       
                //mail body: 'project build successful',
                //from: 'ypodoksik29@gmail.com',
                //subject: 'project build successful',
                //to: 'ypodoksik29@gmail.com'
    
                sh "echo cleanup stage completed."
            }
        }
    }
}
