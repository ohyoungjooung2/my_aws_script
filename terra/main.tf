provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_key_pair" "main_key" {
 key_name = "main_key"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDPxyb7xLwLYIZuLrtrYm0qwID4O1LonYo5CvOI3oLq0XgF4GHSZ9hjjkyHhp4C/JT98FUjn9ZK+RAc3O2ZikUbOfZmJDmNMuPTrioRaPgz+kVOCdz+f/E7O3n7zFNxGX7jqb2fzYJ6UFrbOoZ2F0N0g7pAAEnbTUIPWL/8IR3Qr9F0ECF4f7XHP0+OrVuB90qmzFzIw5fyXHKNrcaZfneV7TTX0TLdGz0a5COTruOIG1s8WHyGLJhrPL60cKvd35un2viucNuTqHrbHV62yYQIlgCeIQ+QP6kFvENPW0lhgBxM6O9y/5n6LgIrXiPQcVqa5dTBfIi7X0SHx/y+AykN oyj@Workstation-oyj-X555QG"
}

resource "aws_instance" "example" {
  ami = "ami-047f7b46bd6dd5d84"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name = "main_key"
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
    
  tags {
     Name = "terraform-example"
  }
}

resource "aws_instance" "example2" {
  ami = "ami-047f7b46bd6dd5d84"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name = "main_key"
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello world!" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  tags {
     Name = "Nerraform-example2"
  }
}

resource "aws_security_group" "main"{
  name = "test"

  ingress {
     from_port = 8080
     to_port = 8080
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {
     from_port = 22
     to_port = 22
     protocol = "tcp"
     cidr_blocks = ["183.101.41.227/32"]

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
  
