provider "aws" {
  region = var.region
}

module "network" {
  source = "./modules/network"
  vpc_cidr = "10.0.0.0/16"
}

module "ecr" {
  source = "./modules/ecr"
  repository_name = "observability"
}

module "nlb" {
  source = "./modules/nlb"
  vpc_id     = module.network.vpc_id
  subnets    = module.network.public_subnet_ids
  ob_nlb_sg_id  = module.network.ob_nlb_sg_id
  ob_nlb_tempo_sg_id = module.network.ob_nlb_tempo_sg_id
  ob_nlb_loki_sg_id = module.network.ob_nlb_loki_sg_id
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id             = module.network.vpc_id
  subnets            = module.network.public_subnet_ids
  ob_ecs_sg_id          = module.network.ob_ecs_sg_id
  container_image    = "${module.ecr.repository_url}:latest"
  execution_role_arn = "arn:aws:iam::082032435474:role/ecsTaskExecutionRole"
  ob_grpc_nlb_target_group_arn = module.nlb.ob_grpc_nlb_target_group_arn
  ob_tempo_nlb_target_group_arn = module.nlb.ob_tempo_nlb_target_group_arn
  ob_loki_nlb_target_group_arn = module.nlb.ob_loki_nlb_target_group_arn
  log_group_name   = "/ecs/ob-ecs"
  log_retention_days = 7
  aws_region = var.region
}

module "amg" {
  source = "./modules/amg"
  name = "ob-grafana"
}

module "amp" {
  source = "./modules/amp"
  alias = "ob-prometheus"
}

module "s3" {
  source = "./modules/s3"
  tempo_s3_name = "ob-tempo-s3"
  loki_s3_name = "ob-loki-s3"
}