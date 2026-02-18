output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = module.cloudfront.cloudfront_domain_name
}

output "website_url" {
  description = "Live website URL"
  value       = "https://${var.domain_name}"
}

output "s3_bucket_name" {
  description = "S3 bucket name for deployments"
  value       = module.s3.bucket_name
}

output "route53_nameservers" {
  description = "Point these at Namecheap"
  value       = module.route53.nameservers
}
