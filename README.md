# joekleve-infra

Infrastructure as Code for [joekleve.com](https://joekleve.com) — provisioned entirely with Terraform on AWS.

## Architecture

```
GitHub Actions (OIDC)
        │
        ▼
    S3 Bucket (private)
        │
        ▼
CloudFront Distribution (CDN + TLS)
        │
        ▼
  Route 53 (DNS)
        │
        ▼
   joekleve.com
```

| Service | Purpose |
|---|---|
| **S3** | Private static asset storage, CloudFront-only access via OAC |
| **CloudFront** | Global CDN, TLS termination, HTTP→HTTPS redirect |
| **ACM** | Automated SSL/TLS certificate with DNS validation |
| **Route 53** | Authoritative DNS, alias records for apex and www |

## Module Structure

```
├── main.tf               # Root module — wires everything together
├── variables.tf          # Input variables (domain name, region)
├── outputs.tf            # CloudFront URL, nameservers, bucket name
├── providers.tf          # AWS provider + us-east-1 alias for ACM
└── modules/
    ├── s3/               # Private bucket + bucket policy + OAC
    ├── acm/              # SSL cert with automatic DNS validation
    ├── cloudfront/       # CDN distribution with React Router support
    └── route53/          # Hosted zone + A records
```

## Security

- **No static credentials** — GitHub Actions authenticates via OIDC, obtaining short-lived temporary credentials per deployment
- **Private S3 bucket** — all public access blocked, served exclusively through CloudFront using Origin Access Control (SigV4)
- **Least-privilege IAM** — GitHub Actions role scoped to only `s3:PutObject`, `s3:DeleteObject`, `s3:ListBucket`, and `cloudfront:CreateInvalidation`
- **TLS 1.2+ enforced** — minimum protocol version set on CloudFront viewer certificate
- **AWS Shield Standard** — automatically applied to CloudFront distribution

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) configured with appropriate credentials
- Domain registered and nameservers pointed to Route 53

## Usage

```bash
# Clone the repo
git clone https://github.com/botdoctor/joekleve-infra.git
cd joekleve-infra

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply
```

After apply, Terraform outputs the Route 53 nameservers. Point your domain registrar to these nameservers before running a full apply so ACM can complete DNS validation.

## Deployment Pipeline

The application repo ([joekleveportfolio](https://github.com/botdoctor/joekleveportfolio)) contains a GitHub Actions workflow that:

1. Builds the React app
2. Authenticates to AWS via OIDC (no stored credentials)
3. Syncs build artifacts to S3
4. Invalidates the CloudFront cache

Every push to `main` deploys automatically.

## Cost

| Service | Monthly Cost |
|---|---|
| Route 53 hosted zone | ~$0.50 |
| S3, CloudFront, ACM | Free tier |
| **Total** | **~$0.50/month** |
