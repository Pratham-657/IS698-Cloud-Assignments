region         = "us-east-1"
project_name   = "tf-mod-webapp"
bucket_name    = "pratham-tf-bucket-1761957735"
ddb_table_name = "user-logins"
instance_type  = "t3.micro"
ami_id         = "" # keep blank; EC2 module will auto-pick AL2023 via SSM
tags = {
  Env     = "dev"
  Project = "tf-mod-webapp"
}
