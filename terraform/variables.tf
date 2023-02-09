# Cloudflare variables
variable "cloudflare_zone" {
  description = "Domain used to expose the GCP VM instance to the Internet"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "Email address for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_token" {
  description = "Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens"
  type        = string
}

variable "cloudflare_r2_access_key_id" {
  description = "Cloudflare R2 Access Key ID"
  type        = string
}

variable "cloudflare_r2_secret_access_key" {
  description = "Cloudflare R2 Secret Access Key"
  type        = string
}
  
variable "cloudflare_r2_account_id" {
  description = "Cloudflare R2 Account ID"
  type        = string
}
  
# Docker variables
variable "docker_containers" {
  description = "List of docker containers to run"
  type        = list(string)
  default     = ["dpw", "python-dpw", "go-dpw", "nodejs-dpw", "rust-dpw", "deno-dpw", "crystal-dpw"]
}
