/************************* VARIABLES *********************************************/
variable "environment" {}

variable "region" {
  description = "The AWS region."
  default     = "us-east-1"
}

variable "name" {
  type        = "string"
  description = "Name of the queue"
}

# variable "policy_name" {
#   type        = "string"
#   description = "Name for policy SID"
# }

variable "account_id" {}

variable "queue_names" {
  type = "list"
}

/************************* VARIABLES *********************************************/

/************************* OUTPUTS ***********************************************/
output "topic_arn" {
  description = "${var.name} dead letter queue URL"
  value       = "${aws_sns_topic.topic.arn}"
}

/************************* OUTPUTS ***********************************************/

