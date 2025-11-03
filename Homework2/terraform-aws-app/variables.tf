variable "region" {
  type    = string
  default = "us-east-1" # or "ap-south-1" — must match your AWS env
}

variable "project_name" {
  type    = string
  default = "tf-mod-webapp"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  type    = list(string)
  default = ["10.0.2.0/24", "10.0.4.0/24"]
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

# Leave blank to auto-pick latest Amazon Linux 2023 via SSM (handled in modules/ec2/main.tf)
variable "ami_id" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type = string
}

variable "ddb_table_name" {
  type    = string
  default = "user-logins"
}

variable "tags" {
  type = map(string)
  default = {
    Env     = "dev"
    Project = "tf-mod-webapp"
  }
}
