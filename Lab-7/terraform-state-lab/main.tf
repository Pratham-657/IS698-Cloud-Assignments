terraform {
  backend "s3" {
    bucket         = "terraform-state-ra10657"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}

resource "aws_instance" "example" {
  ami           = "ami-0bdd88bd06d16ba03"
  instance_type = "t3.micro"
  tags = {
    Name = "Terraform-Test-Instance"
  }
}


