variable "aliases" {
  type    = "list"
  default = ["www.fillup.io", "fillup.io"]
}

variable "aws_region" {
  type    = "string"
  default = "us-east-1"
}

variable "bucket_name" {
  type    = "string"
  default = "www.fillup.io"
}

variable "codeship_username" {
  type    = "string"
  default = "codeship"
}

variable "cert_domain_name" {
  type    = "string"
  default = "*.fillup.io"
}

variable "cloudflare_domain" {
  type    = "string"
  default = "fillup.io"
}

// // Defined as TF_VAR_cloudflare_email_fillupio env var
variable "cloudflare_email_fillupio" {}

variable "cloudflare_subdomain" {
  type    = "string"
  default = "www"
}

// Defined as TF_VAR_cloudflare_token_fillupio env var
variable "cloudflare_token_fillupio" {}
