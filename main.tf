provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    encrypt = true

    bucket = ""
    key    = "remote-state" // this is how the state file will be called
    region = "us-east-1"
  }
}
