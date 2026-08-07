terraform {
  backend "s3" {
    bucket         = "twinku-bkt"
    key            = "three-tier-network/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}