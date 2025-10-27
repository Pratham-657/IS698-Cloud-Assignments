provider "aws" {
  region = "us-east-1"  # Modify region if needed
}
resource "aws_instance" "my_ec2" {
  ami           = "ami-0c02fb55956c7d316"
  instance_type = "t3.micro"
  key_name      = "myKeyPair"
  tags = {
    Name = "Terraform-EC2-Lab"
  }
}

