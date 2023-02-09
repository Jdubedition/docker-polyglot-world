terraform {
  cloud {
    organization = "cfive-dev"
    # Need to pass token in through TF_TOKEN_app_terraform_io environment variable
    # token = ""
    workspaces {
      name = "docker-polyglot-world"
    }
  }


  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    random = {
      source = "hashicorp/random"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13"
}

# 
# Unfortunately, remote state is not supported for Cloudflare R2 at the time
# of writing this.  It can detect the file but it will not write to bucket.
# Instead, we will use Terraform Cloud to store the state.
#
# data "terraform_remote_state" "network" {
#   backend = "s3"
#   config = {
#     bucket = "docker-polyglot-world-terraform"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#     access_key = var.cloudflare_r2_access_key_id
#     secret_key = var.cloudflare_r2_secret_access_key
#     endpoint = "https://${var.cloudflare_r2_account_id}.r2.cloudflarestorage.com"
#     skip_credentials_validation = true
#     # skip_region_validation = true
#     # skip_metadata_api_check = true
#   }
# }

# Providers
provider "cloudflare" {
  api_token    = var.cloudflare_token
}

provider "random" {
}

provider "aws" {
  access_key = var.cloudflare_r2_access_key_id
  secret_key = var.cloudflare_r2_secret_access_key
  # https://developers.cloudflare.com/r2/platform/s3-compatibility/api/#bucket-region
  region = "auto"
  # fix error validating provider credentials: error calling sts:GetCallerIdentity
  # … lookup sts.auto.amazonaws.com on …: no such host
  skip_credentials_validation = true
  # fix Error: Invalid AWS Region: auto
  skip_region_validation = true
  # fix error retrieving account details: AWS account ID not previously found
  # and failed retrieving via all available methods.
  # caused by iam:ListRoles to iam.amazonaws.com
  # and sts:GetCallerIdentity to sts.auto.amazonaws.com
  skip_requesting_account_id = true
  # skip loading instance profile credentials from 169.254.169.254
  skip_metadata_api_check = true
  endpoints {
    # https://developers.cloudflare.com/r2/platform/s3-compatibility/api/
    s3 = "https://${var.cloudflare_r2_account_id}.r2.cloudflarestorage.com"
  }
  # optional: use an alias so you can also use the real aws provider
  alias = "cloudflare_r2"
}

resource "aws_s3_bucket" "test_bucket" {
  provider = aws.cloudflare_r2
  bucket = "docker-polyglot-world-test"
}
