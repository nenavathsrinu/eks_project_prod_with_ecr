
# Create ECR repositories for microservices
locals {
  services = ["product-service","payment-service","search-service","cart-service","frontend-service"]
}

resource "aws_ecr_repository" "services" {
  for_each = toset(local.services)
  name = each.key
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
  tags = { Service = each.key }
}

output "ecr_repos" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}
