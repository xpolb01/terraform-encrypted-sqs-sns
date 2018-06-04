module "new-user" {
  source      = "modules/sns"
  name        = "new-user"
  account_id  = "${var.account_id}"
  environment = "${terraform.workspace}"
  queue_names = ["user", "blog"]
}

module "new-blog" {
  source      = "modules/sns"
  name        = "new-blog"
  account_id  = "${var.account_id}"
  environment = "${terraform.workspace}"
  queue_names = ["blog"]
}
