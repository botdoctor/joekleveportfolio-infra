variable "aws_region" {
  description = "Primary AWS region"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Root domain name"
  type        = string
  default     = "joekleve.com"
}

variable "www_domain_name" {
  description = "WWW subdomain"
  type        = string
  default     = "www.joekleve.com"
}
