pipeline {
	agent any
    	environment {
	    CI = 'true'	
	    registry = "yp29/jenkinsmultibranch"
	    registryCredential = 'dockerhub'
	    dockerImage = ''
	    rep_name = 'yp29-web-app'
	}
	stages {
		stage('Prepare') {
            		steps {
                		sh "echo Preparation stage is running."
                		checkout scm  
                		sh "echo Preparation stage completed."
            		}
        	}
		stage('Build & Publish Image') {
           		steps {
				sh "echo Build & Publish Image stage is running."
				script {
					dockerImage = docker.build registry + ":$rep_name-$BUILD_NUMBER"
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
				sh "echo Build & Publish Image stage completed."
			}
		}
		//stage('Push Image') {
	//		steps{
//				sh "echo Push Image stage is runing."
//				script {
///					docker.withRegistry( '', registryCredential ) {
//						dockerImage.push()
//					}
//				}
//				sh "echo Push Image stage completed."
//			}
//		}	
        	stage('Cleanup') {
            		steps {
                		sh "echo Cleanup stage is running."
                		sh "docker image prune -af"
                		sh "echo cleanup stage completed."
        		    }
        	}
    	}
}
