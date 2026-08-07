terraform {
  backend "s3" {
    bucket         = "twinkuu-bkt"
    key            = "three-tier-network/terraform.tfstate"
    region         = "us-west-2"
    encrypt        = true
  }
}
