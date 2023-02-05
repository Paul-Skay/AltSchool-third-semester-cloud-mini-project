variable "region" {
  type    = string
  default = "eu-west-2"
}

variable "shared_credentials_files" {
  default = ["~/.aws/credentials"]
}

variable "profile" {
  default = "default"
}

variable "project_name" {
  default = "altschool-tf"
}

variable "custom_vpc" {
  type    = string
  default = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "ami_id" {
  type    = string
  default = "ami-0d09654d0a20d3ae2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "domain_name" {
  type    = string
  default = "paulskay.me"
}
variable "sub_domain_name" {
  type    = string
  default = "terraform-test.paulskay.me"
}

variable "filename" {
  type    = string
  default = "./host-inventory"
}

variable "ssh_key" {
  type        = string
  default     = "tfkey"
  description = "SSH key for EC2 instances"
}
