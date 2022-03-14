/*
variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket for the database's remote state"
  type        = string
}
variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
  type        = string
}
*/
variable "db_name" {
  description = "The name to use for all the cluster resources"
  type        = string
  default     = "testmysql"
}

variable "rds_instance_type" {
  type    = string
  default = "db.t2.micro"
}

variable "sec_groups_ids" {
  type = list(string)
}


variable "region" {
    type = string
}

variable multiaz_enabled {
  type        = bool
  default     = false
}

variable "subnet_group_name" {
    type = string
}