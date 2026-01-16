module "rg" {
  source = "../../modules/resource-group"
  env = "dev"
}

module "sa" {
  source = "../../modules/storage-account"
  env = "dev"
  rg_name = module.rg.rg_name
}