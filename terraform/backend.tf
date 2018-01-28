// Change bucket name to your own bucket. I recommend not using same bucket as your
// website to prevent accidental exposure of Terraform state.
terraform {
  backend "s3" {
    bucket         = "fillupio-terraform"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
    profile        = "fillup"             // Change to name of whatever AWS credentials profile you use for your site
  }
}
