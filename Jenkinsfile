pipeline {
    agent any
    environment {
        CI = 'true'
	registry = "yp29/jenkinsmultibranch"
    	registryCredential = 'dockerhub'
    }
	stages {
        stage('Build') {
            steps {
                sh "echo Build stage is runing."
		script {
          		docker.build registry + ":$BUILD_NUMBER"
		}
                sh "echo Build stage completed."
            }
        }
        stage('Cleanup') {
            steps {
                sh "echo Cleanup stage is runing."
                sh "docker image prune -af"
       
                //mail body: 'project build successful',
                //from: 'ypodoksik29@gmail.com',
                //subject: 'project build successful',
                //to: 'ypodoksik29@gmail.com'
    
                sh "echo cleanup stage completed."
            }
        }
    }
}
