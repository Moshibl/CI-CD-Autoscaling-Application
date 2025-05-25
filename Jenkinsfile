pipeline {
  agent Slave

  stages {
    stage('Build Docker') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Docker-hub', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh '''
            echo "$DOCKER_PASS" | sudo docker login -u "$DOCKER_USER" --password-stdin
            sudo docker build -t LandingPage .
            sudo docker tag LandingPage mohamedshibl/LandingPage:latest
            sudo docker image push mohamedshibl/LandingPage:latest
          '''
        }
      }
    }
    stage('Run Ansible Playbook') {
        steps {
          dir('Ansible') {
            sh 'ansible-playbook playbook.yml'
          }
        }
    }
    stage('Print Load Balancer DNS') {
      steps {
        script {
          def tfOutput = readJSON file: "${env.HOME}/TF-Outputs.json"
          def dns = tfOutput['EXT_DNS'].value
          echo "App is running at: ${dns}"
        }
      }}
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
