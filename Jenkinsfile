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

    agent { label 'slave01-ssh' }

    stages {
		stage('Ansible Test') {
			when{ 
				branch "Ansible-Deploy"
			}
			steps{
				sh "echo Ansible tests are running."
				sh "hostname"
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
		stage('Cleanup') {
			steps{
				sh "echo Cleanup stage is running."
				sh "docker image prune -af"
				sh "echo cleanup stage completed."
			}
		}
	}
}   