resource "aws_vpc" "eks-vpc" {
   cidr_block = "10.3.0.0/16"
   tags = "${
     map(
     "Name", "tst-terraform-eks-node",
     "kubernetes.io/cluster/${var.cluster-name}","shared",
     )
   }"
}


data "aws_availability_zones" "available" {}

resource "aws_subnet" "eks-node-subnet" {
  count = 2
  availability_zone = "${data.aws_availability_zones.available.names[count.index]}"
  cidr_block = "10.3.${count.index}.0/24"
  vpc_id = "${aws_vpc.eks-vpc.id}"
  tags = "${
     map(
     "Name", "tst-terraform-eks-node-subnet",
     "kubernetes.io/cluster/${var.cluster-name}","shared",
     )
  }"

}


resource "aws_internet_gateway" "eks-gw" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  tags {
    Name = "tst-terraform-eks-gw"  
  }
}


resource "aws_route_table" "eks-rt" {
  vpc_id = "${aws_vpc.eks-vpc.id}"
  route {
  cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.eks-gw.id}"
  }
}


resource "aws_route_table_association" "eks-rt-association" {
  count = 2
  subnet_id = "${aws_subnet.eks-node-subnet.*.id[count.index]}"
  route_table_id = "${aws_route_table.eks-rt.id}"
}


#Master node security group:
resource "aws_security_group" "eks-cluster-sg" {
  name = "tst-terraform-eks-cluster-sg"
  description = "Cluster communication with worker nodes"
  vpc_id = "${aws_vpc.eks-vpc.id}"
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "tst-terraform-eks-cluster-sg"
  }
}


#Worker node security group:
resource "aws_security_group" "node-sg" {
  name = "tst-terraform-eks-node-sg"
  description = "Security group for all nodes in the cluster"
  vpc_id = "${aws_vpc.eks-vpc.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = "${
    map(
    "Name", "tst-terraform-eks-node-sg",
    "kubernetes.io/cluster/${var.cluster-name}","owned",
    )
  }"
}


resource "aws_security_group_rule" "node-ingress-self" {
  description = "Allow node to communicate with each other"
  from_port = 0
  protocol = "-1"
  security_group_id = "${aws_security_group.node-sg.id}"
  source_security_group_id = "${aws_security_group.node-sg.id}"
  to_port = 65535
  type = "ingress"
}


resource "aws_security_group_rule" "node-ingress-cluster" {
  description = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port = 1025
  protocol = "tcp"
  security_group_id = "${aws_security_group.node-sg.id}"
  source_security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  to_port = 65535
  type = "ingress"
}

resource "aws_security_group_rule" "cluster-ingress-node-https"{
  description = "Allow pods to communicate with the cluster API Server"
  from_port = 443
  protocol = "tcp"
  security_group_id = "${aws_security_group.eks-cluster-sg.id}"
  source_security_group_id = "${aws_security_group.node-sg.id}"
  to_port = 443
  type = "ingress"
}


# IAM ROLE START
resource "aws_iam_role" "cluster-role" {
  name = "tst-terraform-eks-cluster-role"
  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
    {
       "Effect": "Allow",
       "Principal": {
          "Service":"eks.amazonaws.com"
       },
       "Action": "sts:AssumeRole"
    }
   ]
 }
  POLICY
}
 

resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = "${aws_iam_role.cluster-role.name}"
}


resource "aws_iam_role_policy_attachment" "eks-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = "${aws_iam_role.cluster-role.name}"
}


#For Worker nodes, you must create an IAM role with the following IAM policies:
# AmazonEKSWorkerNodePolicy
# AmazonEKSCNIPolicy
# AmazonEC2ContainerRegistryReadOnly

resource "aws_iam_role" "node-role"{
  name = "tst-terraform-eks-node-role"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement" : [
    {
      "Effect": "Allow",
      "Principal": {
         "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
    ]
 }
  POLICY
}


resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = "${aws_iam_role.node-role.name}"
}


resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = "${aws_iam_role.node-role.name}"
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = "${aws_iam_role.node-role.name}"
}


resource "aws_iam_instance_profile" "node-profile" {
  name = "tst-terraform-eks-node-profile"
  role = "${aws_iam_role.node-role.name}"
}

variable "region" {
  default = "ap-northeast-2"
}

variable "cluster-name"{
  default = "tst-terraform-eks-demo"
  type = "string"
}


#eks version
variable "k8s-version"{
  default = "1.12"
}

provider "aws" {
  region = "${var.region}"
  profile = "mfa"
}

resource "aws_eks_cluster" "tst-eks-cluster"{
  name = "${var.cluster-name}"
  role_arn = "${aws_iam_role.cluster-role.arn}"

  vpc_config {
    security_group_ids = ["${aws_security_group.eks-cluster-sg.id}"]
    subnet_ids = ["${aws_subnet.eks-node-subnet.*.id}"]
  }

  depends_on = [
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy",
    "aws_iam_role_policy_attachment.eks-cluster-AmazonEKSServicePolicy",
  ]

}

#Worker node that registers with your amazon eks cluster launched by an autoscaling group.
#After the nodes join the cluster, you can deploy k8s applications to them.
#The worker nodes configuration includes a launch configuration and an Autoscaling group.
#Below data source will fetch the latest ami to launch worker nodes.

data "aws_ami" "eks-worker" {
  most_recent = true
  owners = ["602401143452"]

  filter {
    name = "name"
    values = ["amazon-eks-node-${var.k8s-version}-v*"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

#  filter {
#    name = "platform"
#    values = ["Other Linux"]
#  }
}


# To join the worker nodes to the master, we have to execute bootstrap.sh script.

#To do this, create a user data script to execute on worker nodes while launching. Here we
#defined user data in local variables.

locals {
  node-userdata = <<USERDATA
#!/usr/bin/env bash
set -o xtrace
/etc/eks/bootstrap.sh \
--apiserver-endpoint '${aws_eks_cluster.tst-eks-cluster.endpoint}' \
--b64-cluster-ca '${aws_eks_cluster.tst-eks-cluster.certificate_authority.0.data}' \
'${var.cluster-name}'
USERDATA
}

#resource "aws_key_pair" "main_key" {
# key_name = "main_key"
# public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDemlbI+dKy+CvZLZ1MNv11gW+xhxoEpxEeOTZz0yupusnkSckZuGKUmx116jnpJFxkNspUoeyWUH/qraLnJTfgMYcEl3oyaHFpOk3WVKSSZ8rXpIXArFuzj1QswLSuBh5XK0ZBJoPLauVAb4o6/g+uzxayg2IC4fkvEMGUqZsuBKtoYfw6MsbWy/PKiNnYD1+1Wfay5HYXuQ4RcnhRKJwsxttImYq8W2A/aYb9p8H/rI9kF8GRTtWMn3S0wEmZcDX4/pmpDithajLB19nZpbR/0VeyYTprFaLMszvMDs7yE5sGe7nFBRHlYAqjmbjJZcGvtuVZGbHROgr/7o1Em4c5"
#
#}


resource "aws_launch_configuration" "launch_config" {
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.node-profile.name}"
  image_id = "${data.aws_ami.eks-worker.id}"
  instance_type = "t2.micro"
  name_prefix = "tst-terra-eks-demo"
  security_groups = ["${aws_security_group.node-sg.id}"]
  user_data_base64 = "${base64encode(local.node-userdata)}"
  key_name = "main_key"
  
  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_autoscaling_group" "autoscaling" {
  desired_capacity = 2
  launch_configuration = "${aws_launch_configuration.launch_config.id}"
  max_size = 3
  min_size = 2
  name = "tst-terra-eks-autoscaling"
  vpc_zone_identifier = ["${aws_subnet.eks-node-subnet.*.id}"]

  tag {
    key = "Name"
    value = "tst-terra-eks-node-subnet"
    propagate_at_launch = true
  }

  tag {
    key = "kubernetes.io/cluster/${var.cluster-name}"
    value = "owned"
    propagate_at_launch = true
  }
}



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
