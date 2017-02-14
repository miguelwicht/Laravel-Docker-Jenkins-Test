#!/usr/bin/env groovy

node('Docker-Jenkins-Slave') {
    stage('say-hello') {
        sh "echo 'hello world'"
    }
    stage('build') {
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src\" node /bin/bash -c \"npm install; chown -R 1000:1000 /app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src/node_modules\""
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src\" node /bin/bash -c \"npm run dev\""
    }
}