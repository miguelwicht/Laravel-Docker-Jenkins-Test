#!/usr/bin/env groovy

node('Docker-Jenkins-Slave') {
    stage('say-hello') {
        sh "echo 'hello world'"
    }
    stage('build') {
        sh "docker run --rm -u 1000:1000 -v jenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/Laravel-Docker-Jenkins-Test/web/src\" node npm install"
    }
}