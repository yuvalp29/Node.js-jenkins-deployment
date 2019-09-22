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
	stage('Build / Publish') {
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
	stage('Echo Test') {
		if(env.BRANCH_NAME == "Development" || env.BRANCH_NAME == "Production"){
			sh "echo Test stage is running."
			sh "echo Test stage completed."
		}
	}
    stage('Ansible Test'){
        if(env.BRANCH_NAME == "Ansible-Deploy"){
            sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/TestConnection.yml"
        }
    }
    stage('Ansible Installations'){
        if(env.BRANCH_NAME == "Ansible-Deploy"){
            sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Prerequisites.yml"
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
        else if(env.BRANCH_NAME == "Ansible-Deploy"){
			sh "echo Build/Publish to Development stage using Ansible is running."
			sh "echo Build/Publish to Development stage using Ansible completed."
		}
	}	
	stage('Deploy to Production') {
		if(env.BRANCH_NAME == "Production"){ 
			input message: 'Finished before deploying to production? (Click "Proceed" to continue)'
			sh "echo Deploy for production stage is runing."
			sh "chmod +x ./Deploy_to_Production.sh"
			sh "./Deploy_to_Production.sh ${docker_prod_name} ${registry} ${rep_name_prod} ${commit_id}"
			sh "echo Application lunched on production. Deploy to Production stage completed."   
		}
        else if(env.BRANCH_NAME == "Ansible-Deploy"){
			sh "echo Build/Publish to Production stage using Ansible is running."
			sh "echo Build/Publish to Production stage using Ansible completed."
		}
	}
	stage('Cleanup') {
		sh "echo Cleanup stage is running."
		sh "docker image prune -af"
		sh "echo cleanup stage completed."
	}
}