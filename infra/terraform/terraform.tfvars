# Project Configuration
project_name = "my-eks-project"
environment  = "dev"
region       = "ap-south-1"

# VPC Configuration
vpc_cidr           = "10.0.0.0/16"
availability_zones = ["ap-south-1a", "ap-south-1b"]

# EKS Configuration
eks_cluster_version        = "1.28"
enable_cluster_autoscaler  = true

# Node Groups Configuration
node_groups = {
  general = {
    instance_types = ["t3.small"]
    min_size       = 1
    max_size       = 3
    desired_size   = 2
    capacity_type  = "ON_DEMAND"
    disk_size      = 20
    labels = {
      "node-type" = "general"
      "environment" = "dev"
    }
    taints = []
  }
  spot = {
    instance_types = ["t3.medium", "t3.large"]
    min_size       = 0
    max_size       = 5
    desired_size   = 1
    capacity_type  = "SPOT"
    disk_size      = 30
    labels = {
      "node-type" = "spot"
      "workload-type" = "batch"
    }
    taints = [
      {
        key    = "workload-type"
        value  = "batch"
        effect = "NO_SCHEDULE"
      }
    ]
  }
}

# Tags
tags = {
  Owner       = "DevOps"
  CostCenter  = "Engineering"
  Application = "Kubernetes"
}


db_password = "StrongPostgres123!"
