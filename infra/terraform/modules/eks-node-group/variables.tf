variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the node group"
  type        = string
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where the nodes will be created"
  type        = list(string)
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
  default     = 2
}

variable "capacity_type" {
  description = "Type of capacity associated with the EKS Node Group. Valid values: ON_DEMAND, SPOT"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes"
  type        = number
  default     = 20
}

variable "labels" {
  description = "Key-value map of Kubernetes labels to apply to the nodes"
  type        = map(string)
  default     = {}
}

variable "taints" {
  description = "List of Kubernetes taints to apply to the nodes"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "enable_autoscaler" {
  description = "Enable cluster autoscaler IAM policy"
  type        = bool
  default     = false
}

variable "ec2_ssh_key" {
  description = "EC2 Key Pair name for SSH access to nodes"
  type        = string
  default     = null
}

variable "source_security_group_ids" {
  description = "List of source security group IDs for SSH access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
