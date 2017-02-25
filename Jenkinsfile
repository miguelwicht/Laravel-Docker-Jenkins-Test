#!/usr/bin/env groovy

node('Docker-Jenkins-Slave') {
    stage('build-images') {
        checkout scm
        sh "cd web && docker build -t ${env.JOB_NAME.toLowerCase()}-web-dev -f Dockerfile-dev ."
    }
    stage('install-dependencies') {
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" ${env.JOB_NAME.toLowerCase()}-web-dev /bin/bash -c \"php composer.phar install; chown -R 1000:1000 /app/jenkins/workspace/${env.JOB_NAME}/web/src/vendor\""
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" node /bin/bash -c \"npm install; chown -R 1000:1000 /app/jenkins/workspace/${env.JOB_NAME}/web/src/node_modules\""
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" node /bin/bash -c \"npm run dev\""
    }

    stage('testing') {
        sh "docker run --rm -v dockerjenkins_jenkins-slave:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" ${env.JOB_NAME.toLowerCase()}-web-dev /bin/bash -c \"cp .env.example .env; php artisan key:generate; vendor/bin/phpunit --debug; rm -rf .env\""
    }

    // stage('deployment') {
    //     gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
    //     sh "cd web && docker build -t ${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER} . && cd .."
    //     deploymentImageName = "${env.registry}/${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER}"
    //     imageName = "${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER}"
    //     sh "docker tag ${imageName} ${deploymentImageName}"
    //     sh "docker push ${deploymentImageName}"
    // }
}