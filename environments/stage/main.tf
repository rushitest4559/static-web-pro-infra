module "rg" {
  source = "../../modules/resource-group"
  env = "stage"
}

module "sa" {
  source = "../../modules/storage-account"
  env = "stage"
  rg_name = module.rg.rg_name
}