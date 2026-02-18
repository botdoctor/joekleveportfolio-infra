module "s3" {
  source      = "./modules/s3"
  domain_name = var.domain_name
}

module "acm" {
  source          = "./modules/acm"
  domain_name     = var.domain_name
  www_domain_name = var.www_domain_name
  route53_zone_id = module.route53.zone_id

  providers = {
    aws = aws.us_east_1
  }
}

module "cloudfront" {
  source              = "./modules/cloudfront"
  domain_name         = var.domain_name
  www_domain_name     = var.www_domain_name
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
  acm_certificate_arn = module.acm.certificate_arn
  oac_id              = module.s3.oac_id
}

module "route53" {
  source                  = "./modules/route53"
  domain_name             = var.domain_name
  www_domain_name         = var.www_domain_name
  cloudfront_domain_name  = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = module.cloudfront.cloudfront_hosted_zone_id
}
