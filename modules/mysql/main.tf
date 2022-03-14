/*
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = var.db_remote_state_bucket
    key    = var.db_remote_state_key
    region = var.region
  }
}
*/

data "aws_ssm_parameter" "db_pass" {
  name = "db_master_password"
}

resource "aws_db_instance" "fp-rds" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.rds_instance_type
  db_name                = var.db_name
  username               = "root"
  password               = data.aws_ssm_parameter.db_pass.name
  parameter_group_name   = "default.mysql5.7"
  multi_az               = var.multiaz_enabled
  skip_final_snapshot    = true
  vpc_security_group_ids = var.sec_groups_ids
  db_subnet_group_name   = var.subnet_group_name
}