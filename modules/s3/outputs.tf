output "bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.website.bucket_regional_domain_name
}

output "oac_id" {
  value = aws_cloudfront_origin_access_control.oac.id
}
