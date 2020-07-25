terraform {
  backend "s3" {
    encrypt = true
    bucket  = "base-bucket"
    region  = "us-east-1"
    key     = "terraform/example-service"
  }
}

module "example-service" {
  source = "../modules/fastly-base"
  origins = [
    {
      name = "one"
      host = "origin-one.example.com"
      ssl  = true
    },
    {
      name = "two-https"
      host = "origin-two.example.com"
      ssl  = true
    },
    {
      name = "two-http"
      host = "origin-two.example.com"
      ssl  = false
    }
  ]
  domains = [ "www.example.com", "internal.example.com" ]
  org = [ "1.2.3.4/24/org-ny", "4.5.6.7/24/org-sf", "10.11.12.13/32" ]
  others  = [ "15.16.17.18/32/some-other" ]
}
