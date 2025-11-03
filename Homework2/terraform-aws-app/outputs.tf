output "vpc_id" { value = module.vpc.vpc_id }
output "alb_dns_name" { value = module.alb.alb_dns_name }
output "s3_bucket" { value = module.s3.bucket_name }
output "dynamodb_table" { value = module.dynamodb.table_name }
output "private_instance_id" { value = module.ec2.instance_id }
