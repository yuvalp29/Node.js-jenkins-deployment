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
		        sh "echo Preparations are running."
                checkout scm  
				sh "git rev-parse --short HEAD > .git/commit-id"
				echo "GIT_COMMIT is ${env.GIT_COMMIT}"
				echo ('.git/commit-id').trim()
                //commit_id = readFile('.git/commit-id').trim()
				//commit_id = sh(returnStdout: true, script: "git rev-parse --short HEAD > .git/commit-id").trim()
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
				sh "echo Ansible Tests are running."
	    		//sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/TestConnection.yml"
			}
		}
    	stage('Ansible Installations'){
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
				sh "echo Cleanup stage is running."
				sh "docker image prune -af"
				sh "echo cleanup stage completed."
			}
		}
	}
}   