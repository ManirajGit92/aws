// Define Packer settings for AWS Plugin
packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

// Define Packer variables for AWS
variable "region" {
  type        = string
  description = "AWS region."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type used for building the AMI."
}

variable "ssh_username" {
  type        = string
  description = "SSH username."
}

variable "ssh_private_key_path" {
  type        = string
  description = "SSH private key path."
}

// Use source Amazon EBS to create a new custom AMI
source "amazon-ebs" "alma_linux_9_vm" {
  region                  = var.region
  instance_type           = var.instance_type
  ssh_username            = var.ssh_username
  ssh_private_key_file    = var.ssh_private_key_path

  ami_name                = "sloopstash-alma-linux-9-v1.1.1-ami"
  ami_description         = "AlmaLinux 9 custom AMI built with Packer"
  associate_public_ip_address = true

  // AlmaLinux 9 AMI filter from AWS Marketplace/Community
  source_ami_filter {
    filters = {
      name                = "almalinux-9*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["679593333241"] // AlmaLinux official owner
    most_recent = true
  }

  ssh_interface = "public_ip"

  tags = {
    Name          = "sloopstash-alma-linux-9-v1.1.1-ami"
    Organization  = "sloopstash"
    Region        = var.region
  }
}

// Provisioning essential system packages and tools
build {
  name    = "alma_linux_9_image"
  sources = ["source.amazon-ebs.alma_linux_9_vm"]

  provisioner "shell" {
    inline_shebang = "/bin/bash_
