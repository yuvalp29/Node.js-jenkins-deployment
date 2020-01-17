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
        stage("Preparetion") {
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
						// def usrInput = input id: 'CustomId', message: 'Please Provide Parameters', ok: 'Next', 
						// 			   parameters: [string(defaultValue: 'type your value here', description: 'Please select the environment', name: 'ENVIRONMENT')]
						// echo "$usrInput"

						def userInput = input id: 'userInput', message: 'Please Provide Parameters', ok: 'Next', 
						                parameters: [[$class: 'ChoiceParameterDefinition', choices: [rep_name_dev, rep_name_prod].join('\n'), description: 'Please select the environment', name:'ENVIRONMENT']]
    					
						selectedEnvironment = userInput
					}	
				}
			}
		}
		stage("Build/Push latest image") {
			when{ 
			 	anyOf { 
			 		branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
			 	}
			}
			steps{
				sh "echo Build/Publish to ${selectedEnvironment} is running."
				script{
					if ("${selectedEnvironment}" == "${rep_name_dev}"){
						customImage = docker.build(registry + ":$rep_name_dev-latest", "./DockerFiles/Development")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}
					}
					else{
						customImage = docker.build(registry + ":$rep_name_prod-latest", "./DockerFiles/Production")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}					
					}
				}
			}
		}
		// stage("Application Deployment") {
		// 	when{ 
		// 		branch "UserInputDeploy"
		// 	}
		// 	steps{
		// 		input message: "Finished before deploying to ${selectedEnvironment}? (Click 'Proceed' to continue)"
		// 		sh "echo Deliver for ${selectedEnvironment} stage is runing."
		// 		script{
		// 			if ("${selectedEnvironment}" == "${rep_name_dev}"){
		// 				sh "chmod +x ./Deploy_to_Development.sh"
		// 				sh "./Deploy_to_Development.sh ${docker_dev_name} ${registry} ${rep_name_dev} ${commit_id}"
		// 				sh "echo Application lunched on development. Deploy to Development stage completed."
		// 			}
		// 			else{
		// 				sh "chmod +x ./Deploy_to_Production.sh"
		// 				sh "./Deploy_to_Production.sh ${docker_prod_name} ${registry} ${rep_name_prod} ${commit_id}"
		// 				sh "echo Application lunched on production. Deploy to Production stage completed."   
		// 			}	
		// 		}				
		// 	}
		// }

		stage("Application Deployment") {
			when{ 
				branch "UserInputDeploy"
			}
			steps{
				input message: "Finished before deploying to ${selectedEnvironment}? (Click 'Proceed' to continue)"
				sh "echo Deliver for ${selectedEnvironment} stage is runing."
				sh "chmod +x ./Deploy_to_Development.sh"
				sh "./Deploy_to_Development.sh ${docker_dev_name} ${registry} ${rep_name_dev} ${commit_id}"
				sh "echo Application lunched on development. Deploy to Development stage completed."
					
			}				
		}
		stage("Build/Push base image") {
			when{ 
				anyOf { 
					branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to ${selectedEnvironment} is running."
				script{
					if ("${selectedEnvironment}" == "${rep_name_dev}"){
						customImage = docker.build(registry + ":$rep_name_dev-base", "./DockerFiles/Development")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}
					}
					else{
						customImage = docker.build(registry + ":$rep_name_prod-base", "./DockerFiles/Production")
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