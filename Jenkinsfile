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
		stage('Test Connection') {
			when{ 
				anyOf { 
					branch "Ansible-Deploy"; branch "Terraform-Deploy"
				}
			steps{
				sh "echo Testing connection."
	    		sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/TestConnection.yml"
			}
		}
		stage('Install Prerequisites') {
			when{ 
				branch "Terraform-Deploy"
			}
			steps{
				sh "echo Installing prerequisites."
	    		sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/TestConnection.yml"
			}
		}

		// parallel terraform deployment of Ubuntu VM and Windows VM + validation

		// User input of what VM to crete + Creation + validation

		// Confoguring the vms as jenkins slaves: connecting the VM to the master using ssh configuration

		// Pring a message that says that vm are ready and configured for slave 

		// Ask if use them or  terminate them
		 
		// terraform destroy



    	stage('Ansible Deployment') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible deployment is running."
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Ansible-Deploy.yml"
			}
		}
    	stage('Terraform Deployment') {
			when{ 
				branch "Terraform-Deploy"
			}
			steps{
				sh "echo Terraform deployment is running."
				//sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Ansible-Deploy.yml"
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
		stage('Build/Push Dev base image') {
			when{ 
				anyOf { 
					branch "Development"; branch "Ansible-Deploy"; branch "Terraform-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to Development is running."
				script{
					customImage = docker.build(registry + ":$rep_name_dev-base", "./DockerFiles/Development")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
					}
				}
			}
		}
		stage('Build/Push Prod base image') {
			when{ 
				anyOf { 
					branch "Production"; branch "Ansible-Deploy"; branch "Terraform-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to Production is running."
				script{
					customImage = docker.build(registry + ":$rep_name_prod-base", "./DockerFiles/Production")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
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
