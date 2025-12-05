output "node_group_name" {
  description = "EKS Node Group name"
  value       = aws_eks_node_group.main.node_group_name
}

output "node_group_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Node Group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_id" {
  description = "EKS Cluster Node Group ID"
  value       = aws_eks_node_group.main.id
}

output "node_group_status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}

output "node_group_capacity_type" {
  description = "Type of capacity associated with the EKS Node Group"
  value       = aws_eks_node_group.main.capacity_type
}

output "node_group_instance_types" {
  description = "Set of instance types associated with the EKS Node Group"
  value       = aws_eks_node_group.main.instance_types
}

output "node_group_role_arn" {
  description = "IAM role ARN associated with the EKS Node Group"
  value       = aws_iam_role.node_group.arn
}

output "status" {
  description = "Status of the EKS Node Group"
  value       = aws_eks_node_group.main.status
}
