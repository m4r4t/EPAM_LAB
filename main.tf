resource "aws_db_subnet_group" "master" {
  name       = "master"
  subnet_ids = data.aws_subnets.private.ids

  tags = {
    Name = "My DB subnet group"
  }

  depends_on = [
    aws_subnet.master_private_subnets,
  ]
}





module "mysql" {
  source = "./modules/mysql"

  //db_remote_state_bucket = "epam-lab-tfstate-bucket"
  //db_remote_state_key    = "mysql_tfstate"
  db_name = "mytestmysql"
  //db_master_password     = data.aws_ssm_parameter.db_pass.name
  rds_instance_type = "db.t3.micro"
  multiaz_enabled   = false
  sec_groups_ids    = [aws_security_group.mysql-db-sg.id]
  region            = var.region-master
  subnet_group_name = aws_db_subnet_group.master.name
}



