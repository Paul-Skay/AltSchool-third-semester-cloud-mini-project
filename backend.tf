terraform {
  backend "s3" {
    region         = "eu-west-2"
    profile        = "default"
    bucket         = "skay-remote-tfstate-bucket"
    key            = "skay-remote-tfstate-bucket"
    dynamodb_table = "remote_tfstate_dynamodb_table"
    encrypt        = true
  }
}