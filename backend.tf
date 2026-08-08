terraform {
  backend "s3" {
    bucket         = "chiruuu-oidc"
    key            = "three-tier-network/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
