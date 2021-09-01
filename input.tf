terraform {
  required_providers {
    oktaasa = {
      source = "oktadeveloper/oktaasa"
    }
  }
}

variable "region" {
  description = "Region to deploy the VPC"
  default     = "us-west-1"
}

variable "availability_zone" {
  description = "Availability Zone to deploy the VPC"
  default     = "us-west-1b"
}

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}
variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default     = "10.1.0.0/24"
}

variable "instance_ami" {
  description = "AMI for aws EC2 instance"
  default     = "ami-0d382e80be7ffdae5"
}

variable "instance_type" {
  description = "type for aws EC2 instance"
  default     = "t2.micro"
}

variable "environment_tag" {
  description = "AWS tag to attach to resources"
  default     = "ASATerraformDemo"
}

variable "oktaasa_project" {
  description = "Name of the ASA Project to create"
  default     = "asa-terraform-demo"
}

variable "oktaasa_group" {
  description = "Name of the ASA Group to create and assign"
  default     = "ops-team"
}

provider "aws" {
  region = var.region
}

provider "oktaasa" {
}