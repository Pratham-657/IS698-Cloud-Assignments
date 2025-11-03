variable "project_name" { type = string }
variable "subnet_id" { type = string }
variable "instance_type" { type = string }
variable "ami_id" { type = string }
variable "security_group_id" { type = string }
variable "s3_bucket_name" { type = string }
variable "ddb_table_name" { type = string }
variable "tags" { type = map(string) }
