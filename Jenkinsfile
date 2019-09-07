pipeline {
	agent any
    	environment {
       		CI = 'true'
		registry = "yp29/jenkinsmultibranch"
    		registryCredential = 'dockerhub'
	}
	stages {
		stage('Prepare') {
            		steps {
                		sh "echo Preparation stage is runing."
                		checkout scm    
                		sh "echo Preparation stage completed."
            		}
        	}
       		stage('Build Image') {
           		steps {
				sh "echo Build Image stage is runing."
				script {
					docker.build registry + ":$BUILD_NUMBER"
				}	
				sh "echo Build Image stage completed."
			}
		}	
		stage('Push Image') {
			steps{
				sh "echo Push Image stage is runing."
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
				sh "echo Push Image stage completed."
			}
		}		
        	stage('Cleanup') {
            		steps {
                		sh "echo Cleanup stage is runing."
                		sh "docker image prune -af"
                		sh "echo cleanup stage completed."
        		    }
        	}
    	}
}
