terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  version = "~> 2.22"
  region  = "eu-west-1"
}

provider "template" {
  version = "~> 2.1.2"
}

provider "fastly" {
    version = "~> 0.9"
}
