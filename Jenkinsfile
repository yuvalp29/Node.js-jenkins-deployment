node('slave02-jnlp') {
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
    stage('Ansible Test'){
        if(env.BRANCH_NAME == "Ansible-Deploy"){
            sh "echo Test stage is running."
	    //sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/TestConnection.yml"
        }
    }
    stage('Ansible Installations'){
        if(env.BRANCH_NAME == "Ansible-Deploy"){
            sh "ansible-playbook -i ./Inventory/hosts.ini ./ymlFiles/Prerequisites.yml"
        }
    }
	stage('Cleanup') {
		sh "echo Cleanup stage is running."
		sh "docker image prune -af"
		sh "echo cleanup stage completed."
	}
}
