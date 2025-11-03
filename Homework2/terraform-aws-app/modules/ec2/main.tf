data "aws_iam_policy_document" "assume_ec2" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.assume_ec2.json
  tags               = var.tags
}

data "aws_iam_policy_document" "inline" {
  statement {
    sid     = "S3Read"
    actions = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.s3_bucket_name}",
      "arn:aws:s3:::${var.s3_bucket_name}/*"
    ]
  }

  statement {
    sid = "DDBCrud"
    actions = [
      "dynamodb:PutItem",
      "dynamodb:GetItem",
      "dynamodb:Query",
      "dynamodb:UpdateItem",
      "dynamodb:Scan"
    ]
    resources = ["*"]
  }

  statement {
    sid = "SSMMinimal"
    actions = [
      "ssm:DescribeAssociation",
      "ssm:GetDocument",
      "ssm:ListAssociations",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "inline" {
  name   = "${var.project_name}-ec2-policy"
  policy = data.aws_iam_policy_document.inline.json
}

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.inline.arn
}

resource "aws_iam_instance_profile" "profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

# Pull latest Amazon Linux 2023 AMI for this region via SSM Parameter Store
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

locals {
  chosen_ami = var.ami_id != "" ? var.ami_id : data.aws_ssm_parameter.al2023.value

  user_data = <<-EOT
    #!/bin/bash
    dnf -y update
    dnf -y install nginx
    systemctl enable nginx
    echo "<h1>Private Web Server via ALB</h1><p>Bucket: ${var.s3_bucket_name}</p><p>DynamoDB: ${var.ddb_table_name}</p>" > /usr/share/nginx/html/index.html
    systemctl start nginx
    systemctl enable amazon-ssm-agent || true
    systemctl start amazon-ssm-agent  || true
  EOT
}

resource "aws_instance" "web" {
  ami                         = local.chosen_ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  iam_instance_profile        = aws_iam_instance_profile.profile.name
  user_data                   = local.user_data
  associate_public_ip_address = false

  tags = merge(var.tags, { Name = "${var.project_name}-web" })
}
