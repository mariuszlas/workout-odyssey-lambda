terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.43"
    }
  }

  backend "s3" {
    key    = "tfstate.tfstate"
    bucket = "workout-odyssey-ping-lambda"
    region = "eu-west-2"
  }
}
