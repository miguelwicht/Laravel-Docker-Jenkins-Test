#!/usr/bin/env groovy

node('Docker-Jenkins-Slave') {
    stage('say-hello') {
        sh "echo 'hello world'"
    }
    stage('build') {
        checkout scm
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src\" node /bin/bash -c \"npm install; chown -R 1000:1000 /app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src/node_modules; ls\""
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src\" node /bin/bash -c \"npm run dev\""
        sh "ls -la web/src"
        sh "touch hello-world.txt"
        gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        sh "cd web && docker build -t ${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER} . && cd .."
    }
}