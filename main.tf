locals {
  aws_region   = "us-east-1"
}

provider "aws" {
  region = local.aws_region
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  azs             = ["us-east-1a", "us-east-1b"]
  name            = "main"
  private_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.0.0/24", "10.0.1.0/24"]
  cidr            = "10.0.0.0/16"
  #vpc
  enable_dns_hostnames = true
  enable_classiclink   = false
  #NAT Gateway
  enable_nat_gateway = true
}
module "eks" {
  source = "./modules/eks/"
  vpc_id = module.vpc.vpc_id
  vpc_public_subnet_ids = module.vpc.public_subnets
}
