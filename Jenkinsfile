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
            sudo docker build -t landing_page .
            sudo docker tag landing_page mohamedshibl/landing_page:latest
            sudo docker push mohamedshibl/landing_page:latest
          '''
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

    stage('Checking If TF-Outputs Exists') {
      steps {
          sh 'ls'
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
    always {
      echo 'Cleaning up...'
    }
    success {
      echo 'Pipeline executed successfully!'
    }
    failure {
      echo 'Pipeline failed.'
    }
  }
}
