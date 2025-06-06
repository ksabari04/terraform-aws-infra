pipeline {
  agent any

  environment {
    TF_WORKSPACE = "${env.BRANCH_NAME}" // Use dev or prod
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Terraform Init') {
      steps {
        sh 'terraform init'
      }
    }

    stage('Select/Create Workspace') {
      steps {
        sh 'terraform workspace select $TF_WORKSPACE || terraform workspace new $TF_WORKSPACE'
      }
    }

    stage('Terraform Plan') {
      steps {
        sh 'terraform plan'
      }
    }

    stage('Terraform Apply') {
      steps {
        input message: "Approve Apply for ${env.TF_WORKSPACE}?"
        sh 'terraform apply -auto-approve'
      }
    }
  }
}
