pipeline {
    agent any
    stage ('Test') {
        sh "echo test started"
        sh "echo test completed"
    }
    stage ('Checkout') {
        sh "echo "Checkout!""
    }
    stage ('Cleanup') {
    sh "echo cleanup starting..."
    sh "docker image prune -af"
    sh "echo cleanup finished."
    }
}
