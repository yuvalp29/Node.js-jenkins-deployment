pipeline {
    environment {
        commit_id          = ""
		customImage        = ""
	    registry           = "yp29/jenkinsmultibranch"
	    registryCredential = "dockerhub"
	    rep_name_dev 	   = "development"
	    rep_name_prod 	   = "production"
	    docker_dev_name    = "docker-development-app"
	    docker_prod_name   = "docker-production-app"
    }

    agent { label 'slave02-jnlp' }

    stages {
        stage('Prepare') {
            agent { label 'slave01-ssh' }
            steps {
				sh "hostname"
		        sh "echo Preparations are running."
                checkout scm  
				script{
					//sh "git rev-parse --short HEAD > .git/commit-id"
					//commit_id = readFile('.git/commit-id').trim()
					commit_id = sh(returnStdout: true, script: "git rev-parse --short HEAD > .git/commit-id").trim()
				}
            }
        }
		stage('Build / Publish to Development') {
			when{ 
				branch "Development"
			}
			steps{
				sh "echo Build/Publish to Development is running."
				script{
					customImage = docker.build(registry + ":$rep_name_dev-$commit_id", "./DockerFiles/Development")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
					}
				}
			}
		}
		stage('Build / Publish to Production') {
			when{ 
				branch "Production"
			}
			steps{
				sh "echo Build/Publish to Production is running."
				script{
					customImage = docker.build(registry + ":$rep_name_prod-$commit_id", "./DockerFiles/Production")
					docker.withRegistry( '', registryCredential ) {
						customImage.push()
					}
				}
			}
		}
        stage('Paralell Deployment') {
            parallel {
                stage('Deploy to Development') {
					when{ 
						branch "Ansible-Deploy"
					}
                    steps{
						sh "hostname"
                        sh "echo Deployment to Development is running."   
                    }
                }
                stage('Deploy to Production') {
					when{ 
						branch "Ansible-Deploy"
					}
                    steps{
                        sh "echo Deployment to Production is running." 
                    }
                }
            }
        }
		stage('Ansible Test') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "hostname"
				sh "echo Ansible Tests are running."
	    		//sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/TestConnection.yml"
			}
		}
    	stage('Ansible Installations') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible Installations are running."
				//sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/Prerequisites.yml"
			}
		}
		stage('Cleanup') {
			steps{
				sh "hostname"
				sh "echo Cleanup stage is running."
				sh "docker image prune -af"
				sh "echo cleanup stage completed."
			}
		}
	}
}   