pipeline {
    environment {
        commit_id           = ""
		customImage         = ""
		selectedEnvironment = ""
	    registry            = "yp29/jenkinsmultibranch"
	    registryCredential  = "dockerhub"
	    rep_name_dev 	    = "development"
	    rep_name_prod 	    = "production"

    }

    agent { label 'slave01-ssh' }

    stages {
        stage('Preparetion') {
            steps {
		        sh "echo Preparations are running."
                checkout scm  
				script{
					sh "git rev-parse --short HEAD > .git/commit-id"
					commit_id = readFile('.git/commit-id').trim()
				}
			}
		}
		stage("Get Deploy Environment") {
			steps {
				timeout(time: 45, unit: 'SECONDS') {
					script {
						def usrInput = input id: 'CustomId', message: 'Please Provide Parameters', ok: 'Next', 
									   parameters: [string(defaultValue: 'type your value here', description: 'Please select the environment', name: 'ENVIRONMENT')]
						echo "$usrInput"
					}	
				}
			}
		}
		stage('Build/Push latest image') {
			// when{ 
			// 	anyOf { 
			// 		branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
			// 	}
			// }
			steps{
				sh "echo Build/Publish to $selectedEnvironment is running."
				script{
					if ("$usrInput" == rep_name_dev)
					{
						customImage = docker.build(registry + ":$rep_name_dev-latest", "./DockerFiles/Development")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}
					}
					else
					{
						customImage = docker.build(registry + ":$rep_name_prod-latest", "./DockerFiles/Production")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}					
					}
				}
			}
		}
		stage('Cleanup') {
			steps{
				sh "echo Cleanup stage is running."
				sh "docker image prune -af"
			}
		}
	}
}