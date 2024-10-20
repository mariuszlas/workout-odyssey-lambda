terraform {
  required_version = ">= 1.9.6"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.43"
    }

    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.6.0"
    }
  }

  backend "s3" {
    key    = "tfstate"
    bucket = "workout-odyssey-ping-lambda"
    region = "eu-west-2"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
