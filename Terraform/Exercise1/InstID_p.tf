# main.tf

provider "aws" {
  region = "ap-south-1"
}

# Data source to find Ubuntu AMIs
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical's AWS account ID for Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Output the AMI ID
output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}