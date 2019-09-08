node {
	def commit_id
	def registry = "yp29/jenkinsmultibranch"
	def registryCredential = 'dockerhub'
	def rep_name = 'yp29-web-app'
	def dockerImage = ''

	stage('Prepare') {
		sh "echo Preparation stage is running."
		checkout scm  
		sh "git rev-parse --short HEAD > .git/commit-id"
        	commit_id = readFile('.git/commit-id').trim()
		sh "echo Preparation stage completed."    	
	}
	stage('Build / Publish') {
		sh "echo Build/Publish stage is running."
		dockerImage = docker.build registry + ":$rep_name-$BUILD_NUMBER"
		docker.withRegistry( '', registryCredential ) {
			dockerImage.push()
		}
		sh "echo Build/Publish stage completed."
	}
	stage('Test') {
		sh "echo Test stage is runing."
		//sh './test.sh'
		//sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
		sh "echo Test stage completed."
	}
	stage('Cleanup') {
		sh "echo Cleanup stage is running."
		sh "docker image prune -af"
		sh "echo cleanup stage completed."
	}
}
