module "rg" {
  source = "../../modules/resource-group"
  env = "prod"
}

module "sa" {
  source = "../../modules/storage-account"
  env = "prod"
  rg_name = module.rg.rg_name
}