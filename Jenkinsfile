pipeline {
    environment {
        commit_id          = ""
		customImage        = ""
	    registry           = "yp29/jenkinsmultibranch"
	    registryCredential = "dockerhub"
	    rep_name_dev 	   = "development"
	    rep_name_prod 	   = "production"
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
		stage("Gather Deploy Environment") {
			when{ 
				anyOf { 
					branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
    	    steps {
    	      timeout(time: 30, unit: 'SECONDS') {
    	        script {
    	          // Show the select input modal
    	          def INPUT_PARAMS = input message: 'Please Provide Parameters', ok: 'Next',
    	          parameters: [choice(name: 'ENVIRONMENT', choices: [rep_name_dev,rep_name_prod].join('\n'), description: 'Please select the Environment')]
    	          env.ENVIRONMENT = INPUT_PARAMS.ENVIRONMENT
    	        }
    	      }
			}	
		}

		stage("Use Deploy Parameters") {
        	steps {
          		script {
          		  echo "Selected Environment: ${env.ENVIRONMENT}"
          		}
        	}
      	}

		stage('Build/Push latest image') {
			when{ 
				anyOf { 
					branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to ${env.ENVIRONMENT} is running."
				script{
					if (${env.ENVIRONMENT} == rep_name_dev)
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
		stage('Ansible Test') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible tests are running."
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/TestConnection.yml"
			}
		}
		stage('Ansible Installations') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible installations are running."
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Prerequisites.yml"
			}
		}
		stage('Ansible Deployment') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible deployment is running."
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Ansible-Deploy.yml"
			}
		}
		stage('Kubernetes Deployment') {
			
			agent { label 'k8s' }
			
			when{ 
				branch "Kubernetes-Deploy"
			}
			steps{
				sh "echo Kubernetes deployment is running."
				sh "chmod +x ./scripts/k8s_Deploy.sh"
				sh "./scripts/k8s_Deploy.sh"
			}
		}
		stage('Build/Push base image') {
			when{ 
				anyOf { 
					branch "UserInputDeploy"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to ${env.ENVIRONMENT} is running."
				script{
					if (${env.ENVIRONMENT} == rep_name_dev)
					{
						customImage = docker.build(registry + ":$rep_name_dev-base", "./DockerFiles/Development")
						docker.withRegistry( '', registryCredential ) {
							customImage.push()
						}
					}
					else
					{
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