provider "aws" {
  profile    = var.profile
  region     = var.region-master
  alias      = "region-master-yalk"
  access_key = var.acg_access_key
  secret_key = var.acg_secret_key
}

provider "aws" {
  profile    = var.profile
  region     = var.region-stb
  alias      = "region-stb-yalk"
  access_key = var.acg_access_key
  secret_key = var.acg_secret_key
}

provider "aws" {
  profile    = var.profile
  region     = var.region-master
  access_key = var.m4k3_access_key
  secret_key = var.m4k3_secret_key
  alias      = "m4k3"
}