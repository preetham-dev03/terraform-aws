pipeline {
   agent any
   parameters {
    string(description: 'Enter the Ip address of the instance ', name: 'ipaddress')
  }
   stages {
    stage('Checkout') {
      steps {
        script {
           // The below will clone your repo and will be checked out to main branch by default.
           git branch: 'main', credentialsId: '38ce4052-e691-4254-805b-c2c84613c0b8', url: 'https://github.com/uturndata-public/tech-challenge-flask-app.git'
           // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
           sh "ls -lart ./*"             
          }
       }
    }
    stage('copy Artifact') {
       
        steps {
          withCredentials([sshUserPrivateKey(credentialsId: 'ec2_user', keyFileVariable: 'ec2_key')]) {
            script {
              
              // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
              sh "ls -lart " 
              
              // scp the artifacts
              sh "scp -i ${ec2_key} -o StrictHostKeyChecking=no -r * ubuntu@${params.ipaddress}:/home/ubuntu/"
                          
            }
          }
        }
    }

    stage('install pre requisites') {
       
        steps {
          withCredentials([sshUserPrivateKey(credentialsId: 'ec2_user', keyFileVariable: 'ec2_key')]) {
            script {
              
              // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
              sh "ls -lart " 
              
              // update and install
              sh "ssh -i ${ec2_key} -o StrictHostKeyChecking=no  ubuntu@${params.ipaddress} 'sudo apt update && sudo apt install gunicorn python3-pip -y && python3 -m pip install -r requirements.txt'"
                          
            }
          }
        }
    }

    stage('run application ') {
       
        steps {
          withCredentials([sshUserPrivateKey(credentialsId: 'ec2_user', keyFileVariable: 'ec2_key')]) {
            script {
              
              // Do a ls -lart to view all the files are cloned. It will be clonned. This is just for you to be sure about it.
              sh "ls -lart " 
              
              // run application
              sh "ssh -i ${ec2_key} -o StrictHostKeyChecking=no  ubuntu@${params.ipaddress}  'gunicorn -b 0.0.0.0 app:candidates_app &>/dev/null &'" 
            
            }
          }
        }
    }
  }
}