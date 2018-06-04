resource "aws_sns_topic" "topic" {
  name         = "${var.name}-${var.environment}"
  display_name = "${var.name}-${var.environment}"
}

resource "aws_sns_topic_subscription" "subscription" {
  count                  = "${length(var.queue_names)}"
  topic_arn              = "${aws_sns_topic.topic.arn}"
  protocol               = "sqs"
  endpoint               = "arn:aws:sqs:${var.region}:${var.account_id}:${var.queue_names[count.index]}-queue-${var.environment}"
  endpoint_auto_confirms = true
}
