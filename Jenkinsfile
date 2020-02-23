pipeline {
    environment {
        commit_id             = ""		
		DEPLOYMENT_INPUT      = ""
		TERMINATION_INPUT     = ""
		AZURE_APP_ID          = "e135aa97-15a7-46da-9d2a-6c18e47bf7eb"
		AZURE_PASSWORD        = "3cb64ca4-82f8-495e-bf35-c121e8b316e1"
		AZURE_TENANT          = "093e934e-7489-456c-bb5f-8bb6ea5d829c"
		AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    agent { label 'slave01-ssh' }

    stages {
		// Getting the commit id in GitHub
        stage('Preparation') {
            steps {
		        sh "echo Preparations are running."
                checkout scm  
				script{
					sh "git rev-parse --short HEAD > .git/commit-id"
					commit_id = readFile('.git/commit-id').trim()
				}
            }
        }
		// Pinging to servers using Ansible playbook
		stage('Connection Test') {
			when{ 
				anyOf { 
					branch "Ansible-Deploy"; branch "Terraform-Deploy"
				}
			}
			steps{
				sh "echo Testing connection."
	    		sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/TestConnection.yml"
			}
		}
		// Installing prerequisites using Ansible playbook and inittiating Terraform
		stage('Prerequisites') {
			when{ 
				anyOf { 
					branch "Ansible-Deploy"; branch "Terraform-Deploy"
				}
			}
			steps{
				sh "echo Installing prerequisites and inittialyzing Terraform."
	    		sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/Prerequisites.yml"
				sh "ansible-playbook -i ./Inventory/hosts.ini -u jenkins ./ymlFiles/AzureCLI.yml"
			}
		}
		// Logging to Azure and inittialyzing Terraform
		stage("Terraform Inittialization") {
			when{ 
				branch "Terraform-Deploy"
			}
			steps{
				sh "echo Logging to Azure and inittialyzing Terraform."
				sh "az login --service-principal --username $AZURE_APP_ID --password $AZURE_PASSWORD --tenant $AZURE_TENANT"
				sh "terraform init"
			}
		}
		// Getting from user what vm version to crete
		stage("VM Deployment Option") {
			when{ 
				branch "Terraform-Deploy"
			}
			steps {
				timeout(time: 45, unit: 'SECONDS') {
					script {
						def userInput = input id: 'userInput', message: 'Please Provide Parameters', ok: 'Next', 
						                parameters: [[$class: 'ChoiceParameterDefinition', 
													  choices: ["Deploy both virtual mechines", 
													            "Deploy Linux Ubuntu 16.04 virtual machine", 
																"Deploy Windows Server 2019 virtual machine"].join('\n'), 
													  description: 'Please select deployment option and operating system version', 
													  name:'DEPLOYMENT']]
    					
						// Saving user choise in global variable for furthur steps 
						DEPLOYMENT_INPUT = userInput
					}	
				}
			}
		}
		// TODO:
		// Creating virtual machines according to user's choise + validating the creation
		stage("VM Creation") {
			when{ 
				branch "Terraform-Deploy"
			}
			steps{		
				script{
					if ("${DEPLOYMENT_INPUT}" == "Deploy Linux Ubuntu 16.04 virtual machine") {
						// TODO: Retrieve public IP
						sh """
						echo Creating Azure resources for Linux Ubuntu 16.04 virtual machine.
						terraform plan -target=./tfFiles/Linux_VM.tf
						terraform apply -target=./tfFiles/Linux_VM.tf -auto-approve
						"""
					}
					else if ("${DEPLOYMENT_INPUT}" == "Deploy Windows Server 2019 virtual machine") {
						// TODO: Retrieve public IP
						sh """
                        echo Creating Azure resources for Windows Server 2019 virtual machine.
						terraform plan -target=./tfFiles/Windows_VM.tf
						terraform apply -target=./tfFiles/Windows_VM.tf -auto-approve
                        """
					}
					else {
						// TODO: Retrieve public IP
						sh "echo Creating Azure resources for both Windows and Linux virtual machines."
						parallel {
							stage('Windows Server 2019') {
								when{ 
									branch "Terraform-Deploy"
								}
                    			steps{
									sh """
									terraform plan -target=./tfFiles/Windows_VM.tf
									terraform apply -target=./tfFiles/Windows_VM.tf -auto-approve
                        			"""
                    			}
                			}
							stage('Linux Ubuntu 16.04') {
								when{ 
									branch "Terraform-Deploy"
								}
								steps{
									sh """
									terraform plan -target=./tfFiles/Linux_VM.tf
									terraform apply -target=./tfFiles/Linux_VM.tf -auto-approve
									"""
								}
							}			
						}
					}
				}
			}
		}		
		// TODO:
		stage('Configure Jenkins Slaves') {
			// Configuring the vms as jenkins slaves: connecting the VM to the master using ssh configuration
			// Pring a message that says that vm are ready and configured for slave 
			when{ 
				branch "Terraform-Deploy"
			}
			steps{		
				sh "echo Configuring Jenkins slaves."	
			}
		}
		// Getting from user desicion about terminating Terraform created resources
		stage("Cleanup Option") {
			when{ 
				branch "Terraform-Deploy"
			}
			steps {
				timeout(time: 45, unit: 'SECONDS') {
					script {
						def userInput = input id: 'userInput', message: 'Please Provide Parameters', ok: 'Next', 
						                parameters: [[$class: 'ChoiceParameterDefinition', choices: ["Yes, terminate them", "No, keep them alive"].join('\n'), description: 'Do you want to cleanup all created resources?', name:'TERMINATION']]
    					
						// Saving user choise in global variable for furthur steps 
						TERMINATION_INPUT = userInput
					}	
				}
			}
		}
		// Cleaning the resources 
		stage("Cleanup") {
			when{ 
				branch "Terraform-Deploy"
			}
			steps{		
				sh "echo Cleaning up resources."	
				script{
					if ("${TERMINATION_INPUT}" == "Yes, terminate them") {
						sh "terraform destroy --auto-approve "
					}
				}
				sh "docker image prune -af"
			}
		}
	}
}