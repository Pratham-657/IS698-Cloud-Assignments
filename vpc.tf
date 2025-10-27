resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"  # Example: 10.0.0.0/16
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"  # Example: 10.0.1.0/24
  map_public_ip_on_launch = true
  availability_zone        = "us-east-1a"  # Example: us-east-1a
}

resource "aws_subnet" "private_subnet" {
  vpc_id           = aws_vpc.my_vpc.id
  cidr_block       = "10.0.2.0/24"  # Example: 10.0.2.0/24
  availability_zone = "us-east-1b"  # Example: us-east-1b
}

