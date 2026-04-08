terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "novatech-terraform-state"
    key    = "prod/infrastructure.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# S3 para backups
resource "aws_s3_bucket" "backups" {
  bucket = var.backup_bucket_name
  tags   = local.common_tags
}

resource "aws_s3_bucket_versioning" "backups" {
  bucket = aws_s3_bucket.backups.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "backups" {
  bucket = aws_s3_bucket.backups.id
  rule {
    id     = "expire-old-backups"
    status = "Enabled"
    expiration {
      days = 30
    }
  }
}

# IAM para deploy
resource "aws_iam_user" "deploy" {
  name = "novatech-deploy"
  tags = local.common_tags
}

resource "aws_iam_user_policy" "deploy_s3" {
  name = "novatech-deploy-s3"
  user = aws_iam_user.deploy.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.backups.arn,
        "${aws_s3_bucket.backups.arn}/*"
      ]
    }]
  })
}

locals {
  common_tags = {
    Project     = "NovaTech"
    Environment = var.environment
    ManagedBy   = "Terraform"
    Team        = "infra"
  }
}
