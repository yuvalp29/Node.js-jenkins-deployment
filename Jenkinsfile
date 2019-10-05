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

    agent 'slave02-jnlp'

    stages {
        stage('Prepare') {
            agent 'slave01-ssh'
            steps {
		        sh "echo Preparation stage is running."
                checkout scm  
                sh "git rev-parse --short HEAD > .git/commit-id"
                commit_id = readFile('.git/commit-id').trim()
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
        stage('Build / Publish') {
            steps{        
		        if(env.BRANCH_NAME == "Development"){
		        	sh "echo Build/Publish to Development stage is running."
		        	def customImage = docker.build(registry + ":$rep_name_dev-$commit_id", "./DockerFiles/Development")
		        	docker.withRegistry( '', registryCredential ) {
		        		customImage.push()
		        	}
		        	sh "echo Build/Publish to Development stage completed."
		        }
		        else if(env.BRANCH_NAME == "Production"){
		        	sh "echo Build/Publish to Production stage is running."
		        	def customImage = docker.build(registry + ":$rep_name_prod-$commit_id", "./DockerFiles/Production")
		        	docker.withRegistry( '', registryCredential ) {
		        		customImage.push()
		        	}
		        	sh "echo Build/Publish to Development stage completed."
		        }
            }
        }
		stage('Ansible Test'){
			steps{
				if(env.BRANCH_NAME == "Ansible-Deploy"){
            		sh "echo Test stage is running."
	    			//sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/TestConnection.yml"
        		}
			}
		}
    	stage('Ansible Installations'){
			steps{
    	    	if(env.BRANCH_NAME == "Ansible-Deploy"){
    	    	    sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/Prerequisites.yml"
    	    	}
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