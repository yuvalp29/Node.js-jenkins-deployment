pipeline {
	agent any
    	environment {
	    CI = 'true'	
	    registry = "yp29/jenkinsmultibranch"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
	    repo_name = 'yp29/web-app'
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
					dockerImage = docker.build registry + ":$repo_name"
				}	
				sh "echo Build Image stage completed."
			}
		}	
		stage('Publish Image') {
			steps{
				sh "echo Publish Image stage is runing."
				script {
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
				sh "echo Publish Image stage completed."
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
