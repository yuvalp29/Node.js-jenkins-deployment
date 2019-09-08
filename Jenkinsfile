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
		stage('Build / Publish') {
           		steps {
				sh "echo Build/Publish stage is running."
				script {
					dockerImage = docker.build registry + ":$rep_name-$BUILD_NUMBER"
					docker.withRegistry( '', registryCredential ) {
						dockerImage.push()
					}
				}
				sh "echo Build/Publish stage completed."
			}
		}	
		stage('Test') {
			steps {
                		sh "echo Test stage is runing."
                		//sh './test.sh'
                		//sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
                		sh "echo Test stage completed."
            		}
        	}
		stage('Deliver For Development') {
			when {
                		branch 'Development' 
            		}
            		steps {
                		//sh './deliver-for-development.sh'
                		input message: 'Finished using the web site? (Click "Proceed" to continue)'
                		sh "echo Deliver for development stage is runing."
                		//sh './kill.sh'
                		sh "echo Application deliverd to development. Deliver stage completed."   
            		}
        	}
        	stage('Deploy For Production') {
            		when {
                		branch 'Production'  
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
                		sh "echo Cleanup stage is running."
                		sh "docker image prune -af"
                		sh "echo cleanup stage completed."
			}
		}
    	}
}
