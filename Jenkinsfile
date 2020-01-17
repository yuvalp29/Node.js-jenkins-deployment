pipeline {
    environment {
    commit_id          = ""
	  ustomImage         = ""
	  registry           = "yp29/pythondeploy"
	  registryCredential = "dockerhub"
    }

    agent { label 'slave01-ssh' }

    stages {
      stage('Prepare') {
        steps {
  		    sh "echo Preparations are running."
          checkout scm  
  		    script{
            sh "git rev-parse --short HEAD > .git/commit-id"
            commit_id = readFile('.git/commit-id').trim()
            }
        }
      }
      stage("Gather Deployment Parameters") {
        steps {
          timeout(time: 30, unit: 'SECONDS') {
            script {
              // Show the select input modal
              def INPUT_PARAMS = input message: 'Please Provide Parameters', ok: 'Next',
              parameters: [
                choice(name: 'ENVIRONMENT', choices: ['Development','Test'].join('\n'), description: 'Please select the Environment'),
                choice(name: 'PROGRESS', choices: ['Fit','Fat'].join('\n'), description: 'Please select your progress status')]
                //choice(name: 'IMAGE_TAG', choices: getDockerImages(), description: 'Please select your progress status')]
              env.ENVIRONMENT = INPUT_PARAMS.ENVIRONMENT
              env.PROGRESS = INPUT_PARAMS.PROGRESS
              //env.IMAGE_TAG = INPUT_PARAMS.IMAGE_TAG
            }
          }
        }
      }
      stage("Use Deployment Parameters") {
        steps {
          script {
            echo "All parameters have been set as Environment Variables"
            echo "Selected Environment: ${env.ENVIRONMENT}"
            echo "Selected Progress: ${env.PROGRESS}"
          }
        }
      }
      stage("Get&Print Input") {
        steps {
          script{
            def userInput = input(id: 'userInput', message: 'Let\'s say something?', 
            parameters: [
              [$class: 'TextParameterDefinition', defaultValue: 'type your answer here', description: 'Environment', name: 'Input']])
            echo ("Your input: "+userInput)
          }
        }
      }
    }
}