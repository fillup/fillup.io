variable "aliases" {
  type        = "list"
  default     = ["www.fillup.io", "fillup.io"]
  description = "List of hostname aliases"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "www.fillup.io"
}

variable "codeship_username" {
  default = "codeship"
}

variable "cert_domain_name" {
  default = "*.fillup.io"
}

variable "cloudflare_domain" {
  default = "fillup.io"
}

variable "cloudflare_email_fillupio" {
  type        = "string"
  description = "Defined as TF_VAR_cloudflare_email_fillupio env var"
}

variable "cloudflare_subdomain" {
  default = "www"
}

variable "cloudflare_token_fillupio" {
  type        = "string"
  description = "Defined as TF_VAR_cloudflare_token_fillupio env var"
}
