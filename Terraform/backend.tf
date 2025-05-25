terraform {
  backend "s3" {
    bucket       = "shibl-tf-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}