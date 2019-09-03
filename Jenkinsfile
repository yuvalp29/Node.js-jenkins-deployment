node {
    def commit_id
    
    stage('Preparation') {
        sh "echo Checkout!"
        checkout scm
        sh "git rev-parse --short HEAD > .git/commit-id"
        commit_id = readFile('.git/commit-id').trim()
    }
    stage('Build') {
       //sh "docker-composer build"
       //sh "docker-compose up -d"
        waitUntilServicesReady
    }
    stage('Test') {
        sh "echo test started"
        sh "echo test completed"
        //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction tests-ci"
        //sh "docker-compose exec -T php-fpm composer --no-ansi --no-interaction behat-ci"
    }
    stage ('Cleanup') {
    sh "echo cleanup starting..."
    //sh "docker image prune -af"
    sh "echo cleanup finished."
        
    mail body: 'project build successful',
         from: 'ypodoksik29@gmail.com',
         subject: 'project build successful',
         to: 'ypodoksik29@gmail.com'
    }
}
