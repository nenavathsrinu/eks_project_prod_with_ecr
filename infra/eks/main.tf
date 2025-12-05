
terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  type    = string
  default = "ap-south-1"
}

variable "cluster_name" {
  type    = string
  default = "prod-eks-cluster"
}

variable "node_group_name" {
  type    = string
  default = "prod-node-group"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = ">= 19.0.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"
  subnets         = module.vpc.private_subnets

  vpc_id          = module.vpc.vpc_id

  node_groups = {
    managed_ng = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 2
      instance_types   = ["t3.medium"]
      name             = var.node_group_name
      additional_tags  = { "nodegroup" = "managed" }
    }
  }

  # Create IAM roles for service accounts (IRSA)
  create_iam_role = true
  enable_irsa = true

  iam_service_accounts = [
    {
      name = "aws-load-balancer-controller"
      namespace = "kube-system"
      attach_policy_arns = [aws_iam_policy.aws_lb_controller.arn]
      role_name = "${var.cluster_name}-alb-controller-sa-role"
      create = true
    }
  ]

  tags = {
    Project = "prod-eks"
  }
  manage_aws_auth = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = ">= 4.0.0"

  name = "${var.cluster_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24","10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24","10.0.102.0/24","10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "prod"
  }
}

# IAM policy for ALB controller will be read from iam_policy.json (downloaded by Jenkins before terraform apply)
resource "aws_iam_policy" "aws_lb_controller" {
  name   = "${var.cluster_name}-aws-load-balancer-controller-policy"
  policy = file("${path.module}/iam_policy.json")
}

output "cluster_name" {
  value = module.eks.cluster_id
}

output "kubeconfig_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
