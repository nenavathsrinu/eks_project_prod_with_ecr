
Production-grade EKS + ALB Controller automation (changes made):
- Uses terraform-aws-modules/eks/aws and terraform-aws-modules/vpc/aws to create VPC, EKS cluster, managed node group, and IRSA service account for aws-load-balancer-controller.
- Jenkinsfile downloads the official IAM policy JSON for the AWS Load Balancer Controller before terraform apply, then applies Terraform, updates kubeconfig, installs the Helm chart (service account created via IRSA), and deploys k8s manifests.

Important: The Jenkins agent must have:
- AWS CLI, kubectl, terraform, helm installed
- IAM credentials with permissions to create IAM resources, EKS, VPC, EC2, Route53, etc.
- Access to push Docker images to ECR (update manifests with ECR image URIs)

References:
- AWS Load Balancer Controller IAM policy (official): https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json
- AWS docs for installing ALB Controller with Helm: https://docs.aws.amazon.com/eks/latest/userguide/lbc-helm.html
- Thumbprint details & OIDC provider guidance: https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html


Jenkins agent must have permissions to push to ECR (ecr:GetAuthorizationToken, ecr:BatchCheckLayerAvailability, ecr:PutImage, ecr:InitiateLayerUpload, ecr:UploadLayerPart, ecr:CompleteLayerUpload, ecr:CreateRepository).
