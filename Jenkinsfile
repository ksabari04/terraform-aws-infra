pipeline {
  agent any

  // Define variables here or use Jenkins credentials/parameters
  environment {
    BUCKET_NAME = 'terraform-state-bucket-sabari'       // Your S3 bucket name
    AWS_REGION = 'ap-south-1'                            // Your AWS region
    DYNAMO_TABLE = 'terraform-locks'                     // Your DynamoDB table for locks
  }

  stages {
    stage('Set Terraform Workspace') {
      steps {
        script {
          if (env.BRANCH_NAME == 'production') {
            env.TF_WORKSPACE = 'prod'
          } else if (env.BRANCH_NAME == 'development') {
            env.TF_WORKSPACE = 'dev'
          } else {
            env.TF_WORKSPACE = 'dev'  // fallback to dev for other branches
          }
          echo "Using Terraform workspace: ${env.TF_WORKSPACE}"
        }
      }
    }

    stage('Terraform Init') {
      steps {
        sh """
          terraform init -reconfigure \\
            -backend-config="bucket=${BUCKET_NAME}" \\
            -backend-config="key=${env.TF_WORKSPACE}/terraform.tfstate" \\
            -backend-config="region=${AWS_REGION}" \\
            -backend-config="dynamodb_table=${DYNAMO_TABLE}"
        """
      }
    }

    stage('Terraform Select Workspace') {
      steps {
        sh """
          unset TF_WORKSPACE
          # If workspace does not exist, create it; else select it
          terraform workspace select ${env.TF_WORKSPACE} || terraform workspace new ${env.TF_WORKSPACE}
        """
      }
    }

    stage('Terraform Plan') {
      steps {
        sh """
          terraform plan -var="env=${env.TF_WORKSPACE}"
        """
      }
    }

    stage('Terraform Apply') {
      steps {
        sh """
          terraform apply -auto-approve -var="env=${env.TF_WORKSPACE}"
        """
      }
    }
  }

  post {
    success {
      echo 'Terraform applied successfully!'
    }
    failure {
      echo 'Terraform apply failed!'
    }
  }
}

