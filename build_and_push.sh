#!/bin/bash
set -euo pipefail
REGION="${AWS_REGION:-ap-south-1}"
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
ECR_REGISTRY="${AWS_ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

# ensure repos exist (terraform should have created them)
services=(product-service payment-service search-service cart-service frontend-service)
for svc in "${services[@]}"; do
  repo="${ECR_REGISTRY}/${svc}"
  echo "Building and pushing $svc to $repo"
  docker build -t "${svc}:latest" "./microservices/${svc//-/_}" || true
  docker tag "${svc}:latest" "${repo}:latest"
  aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ECR_REGISTRY}
  docker push "${repo}:latest"
  # replace image in manifests
  find infra/k8s/manifests -type f -name "*.yaml" -exec sed -i "s|image: .*${svc}:latest|image: ${repo}:latest|g" {} \;
done
echo "All images built and pushed."
