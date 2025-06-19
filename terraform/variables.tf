variable "region" {
  type        = string
  default     = "ap-south-1"
  description = "AWS region for ALB, EC2, & RDS"
}

variable "root_domain" {
  type        = string
  description = "The apex domain you own (e.g. krunal.com)"
}

variable "frontend_subdomain" {
  type        = string
  default     = "todo"
  description = "Subdomain for S3 website"
}

variable "api_subdomain" {
  type        = string
  default     = "api"
  description = "Subdomain for API ALB"
}

variable "db_username" {
  type        = string
  description = "Master username for RDS"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Master password for RDS"
}

variable "key_pair_name" {
  type        = string
  description = "Existing EC2 key pair name"
}

variable "allowed_ip" {
  type        = string
  default     = "0.0.0.0/0"
  description = "CIDR allowed to SSH"
}
