<<<<<<< HEAD
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
		stage('Build/Push Dev latest image') {
			when{ 
				anyOf { 
					branch "Development"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to Development is running."
				script{
					customImage = docker.build(registry + ":$rep_name_dev-latest", "./DockerFiles/Development")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
					}
				}
=======
node('slave01-ssh') {
	def commit_id
	def registry = "yp29/jenkinsmultibranch"
	def registryCredential = "dockerhub"
	def rep_name_dev = "development"
	def rep_name_prod = "production"
	def docker_dev_name = "docker-development-app"
	def docker_prod_name = "docker-production-app"
	
	stage('Prepare') {
		sh "echo Preparation stage is running."
		checkout scm  
		sh "git rev-parse --short HEAD > .git/commit-id"
        	commit_id = readFile('.git/commit-id').trim()
		sh "echo Preparation stage completed."    	
	}
	stage('Build / Publish') {
		if(env.BRANCH_NAME == "Development"){
			sh "echo Build/Publish to Development stage is running."
			def customImage = docker.build(registry + ":$rep_name_dev-$commit_id", "./DockerFiles/Development")
			docker.withRegistry( '', registryCredential ) {
				customImage.push()
>>>>>>> master
			}
			sh "echo Build/Publish to Development stage completed."
		}
<<<<<<< HEAD
		stage('Build/Push Prod latest image') {
			when{ 
				anyOf { 
					branch "Production"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
				}
			}
			steps{
				sh "echo Build/Publish to Production is running."
				script{
					customImage = docker.build(registry + ":$rep_name_prod-latest", "./DockerFiles/Production")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
					}
				}
=======
		else if(env.BRANCH_NAME == "Production"){
			sh "echo Build/Publish to Production stage is running."
			def customImage = docker.build(registry + ":$rep_name_prod-$commit_id", "./DockerFiles/Production")
			docker.withRegistry( '', registryCredential ) {
				customImage.push()
>>>>>>> master
			}
			sh "echo Build/Publish to Development stage completed."
		}
<<<<<<< HEAD
        stage('Paralell Job') {
            parallel {
                stage('Development Run') {
					when{ 
						anyOf { 
							branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
						}
					}
                    steps{
                        sh "echo Development run in parallel."   
                    }
                }
                stage('Production Run') {
					when{ 
						anyOf { 
							branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
						}
					}
                    steps{
                        sh "echo Production run in parallel." 
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
		stage('Build/Push Dev base image') {
			when{ 
				anyOf { 
					branch "Development"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
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
					branch "Production"; branch "Ansible-Deploy"; branch "Kubernetes-Deploy"
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
=======
	}
	stage('Test') {
		if(env.BRANCH_NAME == "Development" || env.BRANCH_NAME == "Production"){
			sh "echo Test stage is running."
			//input message: "Finished checking the Image localy and remotly? (Click "Proceed" to continue)"
				//customImage.inside {
				//	sh 'make test'
				//}
			sh "echo Test stage completed."
		}
	}
	stage('Deploy to Development') {
		if(env.BRANCH_NAME == "Development"){
			input message: 'Finished before deploying to development? (Click "Proceed" to continue)'
			sh "echo Deliver for development stage is runing."
			sh "chmod +x ./Deploy_to_Development.sh"
			sh "./Deploy_to_Development.sh ${docker_dev_name} ${registry} ${rep_name_dev} ${commit_id}"
			sh "echo Application lunched on development. Deploy to Development stage completed."   
		}
	}	
	stage('Deploy to Production') {
		if(env.BRANCH_NAME == "Production"){ 
			input message: 'Finished before deploying to production? (Click "Proceed" to continue)'
			sh "echo Deploy for production stage is runing."
			sh "chmod +x ./Deploy_to_Production.sh"
			sh "./Deploy_to_Production.sh ${docker_prod_name} ${registry} ${rep_name_prod} ${commit_id}"
			sh "echo Application lunched on production. Deploy to Production stage completed."   
>>>>>>> master
		}
	}
	stage('Cleanup') {
		sh "echo Cleanup stage is running."
		sh "docker image prune -af"
		sh "echo cleanup stage completed."
	}
} 