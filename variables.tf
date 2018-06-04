variable "region" {
  description = "The AWS region."
  default     = "us-east-1"
}

variable "prefix" {
  default = "blog"
}

variable "account_id" {}

variable "owner" {
  default     = "DevOps"
  description = "The name of the team who manages it"
}

variable "support" {
  default     = "team@yourcompany.com"
  description = "Support contact"
}
