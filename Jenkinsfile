node {
	def commit_id
	def registry = "yp29/jenkinsmultibranch"
	def registryCredential = 'dockerhub'
	def rep_name = 'yp29-web-app'

	stage('Prepare') {
		sh "echo Preparation stage is running."
		checkout scm  
		sh "git rev-parse --short HEAD > .git/commit-id"
        	commit_id = readFile('.git/commit-id').trim()
		sh "echo Preparation stage completed."    	
	}
	stage('Build / Publish') {
		sh "echo Build/Publish stage is running."
		def customImage = docker.build registry + ":$rep_name-$BUILD_NUMBER"
		docker.withRegistry( '', registryCredential ) {
			customImage.push()
		}
		sh "echo Build/Publish stage completed."
	}
	stage('Test') {
		sh "echo Test stage is running."
	    	//customImage.inside {
        	//	sh 'make test'
    		//}
		sh "echo Test stage completed."
	}
	stage('Deliver for Development') {
		if(env.BRANCH_NAME == 'Development'){
			//sh './deliver-for-development.sh'
			input message: 'Finished before delivering for development? (Click "Proceed" to continue)'
			sh "echo Deliver for development stage is runing."
			//sh './kill.sh'
			sh "echo Application deliverd to development. Deliver stage completed."   
		}
	}
        stage('Deploy to Production') {
		if(env.BRANCH_NAME == 'Production'){ 
			//sh './deploy-for-production.sh'
			input message: 'Finished before deploying to production? (Click "Proceed" to continue)'
			sh "echo Deploy for production stage is runing."
			//sh './kill.sh'
			sh "echo Application lunched on production. Deploy stage completed."   
		}
	}
	stage('Cleanup') {
		sh "echo Cleanup stage is running."
		sh "docker image prune -af"
		sh "echo cleanup stage completed."
	}
}
