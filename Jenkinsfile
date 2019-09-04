pipeline {
    agent any

    stages {
        stage('Prepare') {
            steps {
                sh "echo Preparation stage is runing."
                checkout scm
                sh "git rev-parse --short HEAD > .git/commit-id"
                commit_id = readFile('.git/commit-id').trim()
                sh "echo Preparation stage completed."
            }
        }
        stage('Build') {
            steps {
                sh "echo Build stage is runing."
                //sh "docker-composer build"
                //sh "docker-compose up -d"
                //waitUntilServicesReady
                sh 'make' 
                archiveArtifacts artifacts: '**/target/*.jar', fingerprint: true 
                sh "echo Build stage completed."
            }
        }
       stage('Test') {
            steps {
                sh "echo Test stage is runing."
                //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
                //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction behat-ci"
                /* `make check` returns non-zero on test failures,
                * using `true` to allow the Pipeline to continue nonetheless
                */
                sh 'make check || true' 
                junit '**/target/*.xml' 
                sh "echo Test stage completed."
            }
        }
        stage('Deploy') {
            when {
              expression {
                currentBuild.result == null || currentBuild.result == 'SUCCESS' 
              }
            }
            steps {
                sh "echo Deploy stage is runing."
                sh 'make publish'
                sh "echo Deploy stage completed."    
            }
        }
        stage ('Cleanup') {
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
