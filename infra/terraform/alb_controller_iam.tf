
resource "aws_iam_policy" "alb" {
  name   = "${aws_eks_cluster.eks.name}-alb-controller"
  policy = file("${path.module}/iam-alb-controller-policy.json")
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions=["sts:AssumeRoleWithWebIdentity"]
    principals { type="Federated" identifiers=[aws_iam_openid_connect_provider.eks.arn] }
    condition {
      test="StringEquals"
      variable="${replace(data.aws_eks_cluster.eks.identity[0].oidc[0].issuer,"https://","")}:sub"
      values=["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "aws_iam_role" "alb" {
  name               = "${aws_eks_cluster.eks.name}-alb-role"
  assume_role_policy = data.aws_iam_policy_document.trust.json
}

resource "aws_iam_role_policy_attachment" "alb" {
  role       = aws_iam_role.alb.name
  policy_arn = aws_iam_policy.alb.arn
}
