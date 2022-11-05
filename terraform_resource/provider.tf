terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.6.0"
    }
  }
}
provider "aws" {
  access_key = "AKIA2LJX2W3URMAWG3Z6"
  secret_key = "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"
  region     = "us-east-2"
}

