pipeline {
  agent { label 'Slave' }

  environment {
    TF_OUTPUT_FILE = "${env.HOME}/TF-Outputs.json"
  }

  stages {
    stage('Build Docker') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
            docker build -t mohamedshibl/landing_page:latest .
            docker push mohamedshibl/landing_page:latest
          '''
        }
      }
    }

    stage('Refresh Inventory') {
      steps {
        dir('Scripts') {
            withCredentials([[$class: 'AmazonWebServicesCredentialsBinding',credentialsId: 'AWS-Creds']]) {
              sh '''
                chmod 500 InventoryGen.sh
                bash InventoryGen.sh
              '''
            }
        }
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        dir('Ansible') {
          sh 'ansible-playbook backend-playbook.yml'
        }
      }
    }

    stage('Print Load Balancer DNS') {
      steps {
        script {
          def tfOutput = readJSON file: "${TF_OUTPUT_FILE}"
          def dns = tfOutput['EXT_DNS']?.value
          echo "App is running at: ${dns ?: 'DNS not found in TF output'}"
        }
      }
    }
  }

  post {
    success {
      slackSend channel: '#cicd-notifications', color: "good", message: "✅ ${env.JOB_NAME} Build has completed Successfully: #${env.BUILD_NUMBER}"
    }
    failure {
      slackSend channel: '#cicd-notifications', color: "danger", message: "❌ ${env.JOB_NAME} Build Failed: #${env.BUILD_NUMBER}"
    }
  }
}
