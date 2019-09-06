node {
    def commit_id
    
    stage('Prepare') {
        sh "echo Preparation stage is runing."
        checkout scm
        sh "git rev-parse --short HEAD > .git/commit-id"
        commit_id = readFile('.git/commit-id').trim()
        sh "echo Preparation stage completed."
    }
    stage('Build') {
        sh "echo Build stage is runing."
        //sh "docker-composer build"
        //sh "docker-compose up -d"
        //waitUntilServicesReady
        sh "echo Build stage completed."
    }
    stage('Test') {
        sh "echo Test stage is runing."
        //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
        //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction behat-ci"
        sh "echo Test stage completed."
    }
    stage('Deploy') {
        sh "echo Deploy stage is runing."
        sh "echo Application lunched on production. Deploy stage completed."    
    }
    stage ('Cleanup') {
        sh "echo Cleanup stage is runing."
        //sh "docker image prune -af"
       
        //mail body: 'project build successful',
             //from: 'ypodoksik29@gmail.com',
             //subject: 'project build successful',
             //to: 'ypodoksik29@gmail.com'
    
        sh "echo cleanup stage completed."
    }
}
