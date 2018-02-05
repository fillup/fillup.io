// Create S3 bucket and CloudFront distribution using Terraform module designed for S3/CloudFront
// configuration of a Hugo site. See: https://registry.terraform.io/modules/fillup/hugo-s3-cloudfront/aws/1.0.1
module "hugosite" {
  source         = "fillup/hugo-s3-cloudfront/aws"
  version        = "1.0.1"
  aliases        = ["${var.aliases}"]
  aws_region     = "${var.aws_region}"
  bucket_name    = "${var.bucket_name}"
  cert_domain    = "${var.cert_domain_name}"
  cf_default_ttl = "0"
  cf_max_ttl     = "0"
}

// Create IAM user with limited permissions for Codeship to deploy site to S3
resource "aws_iam_user" "codeship" {
  name = "${var.codeship_username}"
}

resource "aws_iam_access_key" "codeship" {
  user = "${aws_iam_user.codeship.name}"
}

data "template_file" "policy" {
  template = "${file("${path.module}/bucket-policy.json")}"

  vars {
    bucket_name = "${var.bucket_name}"
  }
}

resource "aws_iam_user_policy" "codeship" {
  policy = "${data.template_file.policy.rendered}"
  user   = "${aws_iam_user.codeship.name}"
}

// Create DNS CNAME record on Cloudflare
resource "cloudflare_record" "www" {
  domain     = "${var.cloudflare_domain}"
  name       = "${var.cloudflare_subdomain}"
  type       = "CNAME"
  value      = "${module.hugosite.cloudfront_hostname}"
  proxied    = true
  depends_on = ["module.hugosite"]
}
