terraform {
  backend "s3" {
    bucket         = "chiruu-oidc"
    key            = "three-tier-network/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
