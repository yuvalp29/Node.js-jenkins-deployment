pipeline {
    environment {
        commit_id = ""
	    registry = "yp29/jenkinsmultibranch"
	    registryCredential = "dockerhub"
	    rep_name_dev = "development"
	    rep_name_prod = "production"
	    docker_dev_name = "docker-development-app"
	    docker_prod_name = "docker-production-app"
    }

    agent { label 'slave02-jnlp' }

    stages {
        stage('Prepare') {
            agent { label 'slave01-ssh' }
            steps {
		        sh "echo Preparation stage is running."
                checkout scm  
				//commit_id = sh(returnStdout: true, script: "git rev-parse --short HEAD > .git/commit-id").trim()
                sh "echo Preparation stage completed."   
            }
        }
        stage('Paralell Runs'){
            parallel {
                stage('First Run') {
                    steps{
                        sh "echo First parallel run completed."   
                    }
                }
                stage('Second Run') {
                    steps{
                        sh "echo Second parallel run completed."   
                    }
                }
                stage('Third Run') {
                    steps{
                        sh "echo Third parallel run completed."   
                    }
                }
            }
        }
		stage('Ansible Test'){
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Test stage is running."
	    		//sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/TestConnection.yml"
			}
		}
    	stage('Ansible Installations'){
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/Prerequisites.yml"
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