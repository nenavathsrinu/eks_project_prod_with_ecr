variable "project_name" {}
variable "environment" {}
variable "tags" {
  type = map(string)
}

variable "vpc_id" {}
variable "vpc_cidr" {}

variable "private_subnet_ids" {
  type = list(string)
}

variable "db_name" {
  default = "shopdb"
}

variable "db_username" {
  default = "postgress"
}

variable "db_password" {
  sensitive = true
}

variable "instance_class" {
  default = "db.t3.micro"
}

variable "allocated_storage" {
  default = 20
}

variable "engine_version" {
  default = "17.6"
}
