locals {
config_map_aws_auth =<<CF
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
      - rolearn: ${aws_iam_role.node-role.arn}
        username: system:node:{{EC2PrivateDNSName}}
        groups:
          - system:bootstrappers
          - system:nodes
CF
}
output "config_map_aws_auth"{
  value = "${local.config_map_aws_auth}"
}

