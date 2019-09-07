pipeline {
    agent any
    environment {
        CI = 'true'
    }
	stages {
        stage('Build') {
            steps {
                sh "echo Build stage is runing."
                sh "docker build -t yuvalp29-web-app -f ./Dockerfile .
                sh "docker push yuvalp29-web-app"
			
                //docker.withRegistry('https://registry.example.com', 'dockerhub') {
					/* Push the container to the custom Registry */
				//	appImage = docker.build("my-image:${env.BUILD_ID}").push()
			//	}

                sh "echo Build stage completed."
            }
        }
        stage('Cleanup') {
            steps {
                sh "echo Cleanup stage is runing."
                sh "docker image prune -af"
       
                //mail body: 'project build successful',
                //from: 'ypodoksik29@gmail.com',
                //subject: 'project build successful',
                //to: 'ypodoksik29@gmail.com'
    
                sh "echo cleanup stage completed."
            }
        }
    }
}
