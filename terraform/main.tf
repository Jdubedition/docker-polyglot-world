terraform {
  cloud {
    organization = "cfive-dev"
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
    local = {
      source = "hashicorp/local"
    }
  }
  required_version = ">= 0.13"
}

# Providers
provider "cloudflare" {
  api_token    = var.cloudflare_token
}

provider "random" {
}

provider "local" {
}
