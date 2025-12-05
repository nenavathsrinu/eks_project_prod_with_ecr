
pipeline {
  agent any
  environment {
    AWS_REGION = 'ap-south-1'
  }
  stages {
    stage('Prep IAM policy') {
      steps {
        dir('infra/eks') {
          sh '''
            # download official IAM policy for AWS Load Balancer Controller (specific release recommended)
            curl -fsSL -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
          '''
        }
      }
    }
    stage('Terraform Init & Apply') {
      steps {
        dir('infra/eks') {
          sh 'terraform init -upgrade'
          sh 'terraform apply -auto-approve'
        }
      }
    }
    stage('Configure kubeconfig') {
      steps {
        dir('infra/eks') {
          sh '''
            aws eks update-kubeconfig --name $(terraform output -raw cluster_name) --region ${AWS_REGION}
          '''
        }
      }
    }
    stage('Build & Push Docker Images to ECR') {
      steps {
        sh './build_and_push.sh'
      }
    }
    stage('Install AWS Load Balancer Controller with Helm') {
      steps {
        sh '''
          helm repo add eks https://aws.github.io/eks-charts
          helm repo update
          # install; module created IRSA role and service account; helm release must reference image tag and clusterName
          helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \\ 
            --namespace kube-system \\ 
            --set clusterName=$(terraform -chdir=infra/eks output -raw cluster_name) \\ 
            --set serviceAccount.create=false \\ 
            --set serviceAccount.name=aws-load-balancer-controller
        '''
      }
    }
    stage('Deploy K8s Manifests') {
      steps {
        sh 'kubectl apply -f infra/k8s/manifests'
      }
    }
  }
  post {
    always {
      echo 'Pipeline finished'
    }
  }
}
