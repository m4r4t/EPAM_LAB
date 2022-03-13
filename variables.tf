variable "profile" {
  type        = string
  default     = "default"
  description = "description"
}

variable "region-master" {
  type    = string
  default = "eu-west-1"
}

variable "region-stb" {
  type    = string
  default = "eu-west-2"
}

variable "master_vpc_cidr" {
  type = string
}

variable "master_public_subnets" {
  type = list(string)
}

variable "master_private_subnets" {
  type = list(string)
}

variable "instance-type" {
  type    = string
  default = "t3.micro"
}

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
variable "acg_access_key" {
  type        = string
  description = "Access key for yalkuns acc"
}

variable "acg_secret_key" {
  type        = string
  description = "Access key for yalkuns acc"
}

variable "m4k3_access_key" {
  type        = string
  description = "access key for m4k3 acc"
}

variable "m4k3_secret_key" {
  type        = string
  description = "secret key for m4k3 acc"
}
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
variable "dns-name" {
  type        = string
  default     = "aws4kz.com."
  description = "aws4kz.com domain"
}
