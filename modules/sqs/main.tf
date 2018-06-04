resource "aws_sqs_queue" "dead_letter_queue" {
  name                      = "${var.name}-dead-letter-queue-${var.environment}"
  message_retention_seconds = 432000

  kms_master_key_id                 = "${var.key_id}"
  kms_data_key_reuse_period_seconds = 300

  tags {
    Name        = "${var.name}-dead-letter-queue"
    Owner       = "${var.owner}"
    Support     = "${var.support}"
    Environment = "${var.environment}"
  }
}

resource "aws_sqs_queue" "queue" {
  name                      = "${var.name}-queue-${var.environment}"
  delay_seconds             = 0
  message_retention_seconds = 86400
  redrive_policy            = "{\"deadLetterTargetArn\":\"${aws_sqs_queue.dead_letter_queue.arn}\",\"maxReceiveCount\":100}"

  kms_master_key_id                 = "${var.key_id}"
  kms_data_key_reuse_period_seconds = 300

  tags {
    Name        = "${var.name}-queue"
    Owner       = "${var.owner}"
    Support     = "${var.support}"
    Environment = "${var.environment}"
  }
}
