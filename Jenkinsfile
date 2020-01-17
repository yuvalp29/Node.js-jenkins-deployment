pipeline {
    environment {
    commit_id          = ""
	  ustomImage         = ""
	  registry           = "yp29/pythondeploy"
	  registryCredential = "dockerhub"
    }

    agent { label 'slave01-ssh' }

    stages {
      stage('Prepare') {
        steps {
  		    sh "echo Preparations are running."
          	checkout scm  
			script{
            	sh "git rev-parse --short HEAD > .git/commit-id"
            	commit_id = readFile('.git/commit-id').trim()
            }
        }
      }
	  stage("Gather Deployment Parameters") {
		  steps {
			  timeout(time: 30, unit: 'SECONDS') {
				  script {
					  def userInput = input id: 'CustomId', message: 'Please Provide Parameters', ok: 'Next', parameters: [string(defaultValue: 'type your value here', description: 'Please select the Environment', name: 'ENVIRONMENT')]
            		  echo "Selected Environment: $userInput"
					  echo "Selected Environment: $userInput.ENVIRONMENT"
  				  }	
			  }
		  }
	  }
	}
}