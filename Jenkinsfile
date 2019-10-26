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
		stage('Build / Publish to Development') {
			when{ 
				anyOf { 
					branch "Development"; branch "Ansible-Deploy" 
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
			}
		}
		stage('Build / Publish to Production') {
			when{ 
				anyOf { 
					branch "Production"; branch "Ansible-Deploy" 
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
			}
		}
        stage('Paralell Job') {
            parallel {
                stage('Development Run') {
					when{ 
						branch "Ansible-Deploy"
					}
                    steps{
                        sh "echo Development run in parallel."   
                    }
                }
                stage('Production Run') {
					when{ 
						branch "Ansible-Deploy"
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
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Deploy.yml"
			}
		}
		stage('Cleanup') {
			steps{
				sh "echo Cleanup stage is running."
				sh "docker image prune -af"
				sh "echo cleanup stage completed."
			}
		}
	}
}   