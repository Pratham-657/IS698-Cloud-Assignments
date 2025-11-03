module "vpc" {
  source          = "./modules/vpc"
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  tags            = var.tags
}

module "security" {
  source       = "./modules/security"
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
  tags         = var.tags
}

module "s3" {
  source       = "./modules/s3"
  bucket_name  = var.bucket_name
  project_name = var.project_name
  tags         = var.tags
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  table_name   = var.ddb_table_name
  project_name = var.project_name
  tags         = var.tags
}

module "ec2" {
  source            = "./modules/ec2"
  project_name      = var.project_name
  subnet_id         = module.vpc.private_subnet_ids[0]
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  security_group_id = module.security.ec2_sg_id
  s3_bucket_name    = module.s3.bucket_name
  ddb_table_name    = module.dynamodb.table_name
  tags              = var.tags
}

module "alb" {
  source             = "./modules/alb"
  project_name       = var.project_name
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  target_instance_id = module.ec2.instance_id
  tags               = var.tags
}
