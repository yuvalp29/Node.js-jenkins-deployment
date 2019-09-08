pipeline {
	agent any
    	environment {
	    CI = 'true'	
	    registry = "yp29/jenkinsmultibranch"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
	    rep_name = 'yp29/web-app'
	}
	stages {
		stage('Prepare') {
            		steps {
                		sh "echo Preparation stage is running."
                		checkout scm  
                		sh "echo Preparation stage completed."
            		}
        	}
       		stage('Build Image') {
           		steps {
				sh "echo Build Image stage is running."
				script {
					dockerImage = docker.build registry + ": " + "$rep_name:" + "$BUILD_NUMBER" 
				}	
				sh "echo Build Image stage completed."
			}
		}	
		stage('Publish Image') {
			steps{
				sh "echo Publish Image stage is running."
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
                		sh "echo Cleanup stage is running."
                		sh "docker image prune -af"
                		sh "echo cleanup stage completed."
        		    }
        	}
    	}
}
