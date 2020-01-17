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
					  def hello = input id: 'CustomId', message: 'Want to continue?', ok: 'Yes', parameters: [string(defaultValue: 'world', description: '', name: 'hello')]
            		  echo "Selected Environment: $hello"
  				  }	
			  }
		  }
	  }
	}
}