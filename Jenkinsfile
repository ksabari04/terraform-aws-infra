pipeline {
  agent any

  environment {
    AWS_REGION   = 'ap-south-1'
    BUCKET_NAME  = 'terraform-state-bucket-sabari'
    DYNAMO_TABLE = 'terraform-locks'
    TF_WORKSPACE = "${env.GIT_BRANCH == 'origin/production' ? 'prod' : 'dev'}"
  }

  stages {
    stage('Terraform Init') {
      steps {
        sh """
          terraform init \
            -backend-config="bucket=${BUCKET_NAME}" \
            -backend-config="key=${TF_WORKSPACE}/terraform.tfstate" \
            -backend-config="region=${AWS_REGION}" \
            -backend-config="dynamodb_table=${DYNAMO_TABLE}"
            -reconfigure
        """
      }
    }

    stage('Terraform Workspace') {
      steps {
        sh """
          terraform workspace select ${TF_WORKSPACE} || terraform workspace new ${TF_WORKSPACE}
        """
      }
    }

    stage('Terraform Plan') {
      steps {
        sh "terraform plan"
      }
    }

    stage('Terraform Apply') {
      steps {
        sh "terraform apply -auto-approve"
      }
    }
  }
}

