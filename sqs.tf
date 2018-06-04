data "aws_iam_policy_document" "sqs_key_policy" {
  policy_id = "sqs-sms-key-policy-${terraform.workspace}"

  statement {
    sid = "Enable IAM User Permissions"

    actions = ["kms:*"]

    principals = {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
    }

    resources = ["*"]
  }

  statement {
    sid = "SNS decrypt permission"

    actions = ["kms:GenerateDataKey*", "kms:Decrypt"]

    principals = {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }

    resources = ["*"]
  }
}

resource "aws_kms_key" "sqs-encryption-key" {
  description = "This key is used for encryption of SQS queues"
  policy      = "${data.aws_iam_policy_document.sqs_key_policy.json}"

  tags {
    Name        = "sqs-encryption-key-${terraform.workspace}"
    Owner       = "${var.owner}"
    Support     = "${var.support}"
    Environment = "${terraform.workspace}"
  }
}

locals {
  user_topic_arns = ["${module.new-user.topic_arn}"]
  blog_topic_arns = ["${module.new-user.topic_arn}", "${module.new-blog.topic_arn}"]
}

######################################## USER #############################################
module "user_sqs" {
  source      = "modules/sqs"
  region      = "${var.region}"
  environment = "${terraform.workspace}"
  name        = "user"
  key_id      = "${aws_kms_key.sqs-encryption-key.id}"
}

resource "aws_sqs_queue_policy" "user_sqs_policy" {
  queue_url = "${module.user_sqs.queue_id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Id": "sns-to-user-queue-${terraform.workspace}-sqspolicy",
  "Statement":[
    {
      "Sid":"SNSToSQSPolicy${terraform.workspace}",
      "Effect":"Allow",
      "Principal":"*",
      "Action":"sqs:SendMessage",
      "Resource":"${module.user_sqs.queue_arn}",
      "Condition":{
        "ArnEquals":{
          "aws:SourceArn": ${jsonencode(local.user_topic_arns)}
        }
      }
    }
  ]
}
POLICY
}

######################################## USER #############################################

######################################## BLOG #############################################
module "blog_sqs" {
  source      = "modules/sqs"
  region      = "${var.region}"
  environment = "${terraform.workspace}"
  name        = "blog"
  key_id      = "${aws_kms_key.sqs-encryption-key.id}"
}

resource "aws_sqs_queue_policy" "blog_sqs_policy" {
  queue_url = "${module.blog_sqs.queue_id}"

  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Id": "sns-to-blog-queue-${terraform.workspace}-sqspolicy",
  "Statement":[
    {
      "Sid":"SNSToSQSPolicy${terraform.workspace}",
      "Effect":"Allow",
      "Principal":"*",
      "Action":"sqs:SendMessage",
      "Resource":"${module.blog_sqs.queue_arn}",
      "Condition":{
        "ArnEquals":{
          "aws:SourceArn": ${jsonencode(local.blog_topic_arns)}
        }
      }
    }
  ]
}
POLICY
}

######################################## BLOG #############################################

