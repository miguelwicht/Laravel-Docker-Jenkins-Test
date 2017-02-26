#!/usr/bin/env groovy

node('docker') {
    stage('build-images') {
        checkout scm
        sh "cd web && docker build -t ${env.JOB_NAME.toLowerCase()}-web-dev -f Dockerfile-dev ."
    }
    stage('install-dependencies') {
        
        parallel (
            composer: {
                sh "docker run --rm -v jenkins-node-data:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" ${env.JOB_NAME.toLowerCase()}-web-dev /bin/bash -c \"php composer.phar install; chown -R 1000:1000 /app/jenkins/workspace/${env.JOB_NAME}/web/src/vendor\""
            },
            npm: {
                sh "docker run --rm -v jenkins-node-data:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" node /bin/bash -c \"npm install; chown -R 1000:1000 /app/jenkins/workspace/${env.JOB_NAME}/web/src/node_modules\""
                sh "docker run --rm -v jenkins-node-data:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" node /bin/bash -c \"npm run dev\""
            }
        )
    }

    stage('testing') {
        sh "docker run --rm -v jenkins-slave-data:\"/app\" -w=\"/app/jenkins/workspace/${env.JOB_NAME}/web/src\" ${env.JOB_NAME.toLowerCase()}-web-dev /bin/bash -c \"cp .env.example .env; php artisan key:generate; vendor/bin/phpunit --debug; rm -rf .env\""
    }

    stage('deployment') {
        gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
        sh "cd web && docker build -t ${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER} . && cd .."
        deploymentImageName = "${env.registry}/${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER}"
        imageName = "${env.JOB_NAME.toLowerCase()}:${gitCommit}-${env.BUILD_NUMBER}"
        sh "docker tag ${imageName} ${deploymentImageName}"
        
        withCredentials([[$class: 'UsernamePasswordMultiBinding', credentialsId: 's3-nexus-registry', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD']]) {
            sh "docker login -u $USERNAME -p $PASSWORD ${env.registry}"
        }
        
        sh "docker push ${deploymentImageName}"

        sh "docker logout ${env.registry}"
    }

    stage('get-secret-file') {
        withCredentials([[
            $class: 'FileBinding',
            credentialsId: 'laravel-jenkins-test-env-docker-compose-staging',
            variable: 'DOCKER-COMPOSE_ENV_FILE'
        ]]) {

            sh 'cp $DOCKER-COMPOSE_ENV_FILE .env'
            sh 'cat .env'
        }
    }
}