
resource "kubernetes_service_account" "alb" {
  metadata {
    name="aws-load-balancer-controller"
    namespace="kube-system"
    annotations={ "eks.amazonaws.com/role-arn"=aws_iam_role.alb.arn }
  }
}

resource "helm_release" "alb" {
  name="aws-load-balancer-controller"
  repository="https://aws.github.io/eks-charts"
  chart="aws-load-balancer-controller"
  namespace="kube-system"
  set { name="clusterName" value=aws_eks_cluster.eks.name }
  set { name="serviceAccount.create" value="false" }
  set { name="serviceAccount.name" value="aws-load-balancer-controller" }
  set { name="region" value=var.region }
  set { name="vpcId" value=aws_vpc.main.id }
}
