provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web_count" {
  count = 3  # Creates 3 instances

  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"

  tags = {
    Name = "Terraform-Instance-${count.index}"
  }
}

variable "instances" {
  type = map
  default = {
    "web1" = "t3.micro"
    "web2" = "t3.micro"
    "web3" = "t3.small"
  }
}

resource "aws_instance" "web_each" {
  for_each = var.instances

  ami           = "ami-0f9c6511313201a5b"
  instance_type = each.value

  tags = {
    Name = "${each.key}"
  }
}

