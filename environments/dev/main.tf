provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source     = "../../modules/vpc"
  cidr_block = "10.0.0.0/16"
}

module "security_groups" {
  source = "../../modules/security-groups"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source     = "../../modules/ec2"
  ec2_sg_id  = module.security_groups.ec2_sg_id
}

module "alb" {
  source          = "../../modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg_id       = module.security_groups.alb_sg_id
}


module "autoscaling" {
  source             = "../../modules/autoscaling"
  private_subnets    = module.vpc.private_subnets
  target_group_arn   = module.alb.target_group_arn
  launch_template_id = module.ec2.launch_template_id
}

module "rds" {
  source           = "../../modules/rds"
  private_subnets  = module.vpc.private_subnets
  rds_sg_id        = module.security_groups.rds_sg_id
}
