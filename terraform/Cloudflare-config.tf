# Generates a 35-character secret for the tunnel.
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# Creates a new locally-managed tunnel
resource "cloudflare_argo_tunnel" "auto_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "terraform-docker-polyglot-world-tunnel"
  secret     = random_id.tunnel_secret.b64_std
}

# Loop through the list of docker containers and create a CNAME record for each.
resource "cloudflare_record" "dpw" {
  for_each = toset(var.docker_containers)
  zone_id  = var.cloudflare_zone_id
  name     = each.value
  value    = "${cloudflare_argo_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type     = "CNAME"
  proxied  = true
}

# Loop through the list of docker containers and create an Access application for each.
resource "cloudflare_access_application" "dpw" {
  for_each = toset(var.docker_containers)
  zone_id          = var.cloudflare_zone_id
  name             = "Access application for ${each.value}.${var.cloudflare_zone}"
  domain           = "${each.value}.https_app.${var.cloudflare_zone}"
  session_duration = "1h"
}

# Loop through the list of docker containers and create an Access policy for each.
resource "cloudflare_access_policy" "http_policy" {
  for_each = toset(var.docker_containers)
  application_id = cloudflare_access_application.dpw[each.value].id
  zone_id        = var.cloudflare_zone_id
  name           = "Example policy for ${each.value}.${var.cloudflare_zone}"
  precedence     = "1"
  decision       = "allow"
  include {
    email = [var.cloudflare_email]
  }
}

resource "local_file" "cloudflared-cert" {
  content = jsonencode({
    AccountTag   = var.cloudflare_account_id
    TunnelID     = cloudflare_argo_tunnel.auto_tunnel.id
    TunnelName   = cloudflare_argo_tunnel.auto_tunnel.name
    TunnelSecret = random_id.tunnel_secret.b64_std
  })
  filename = "${path.module}/cloudflared/cert.json"
}

resource "local_file" "cloudflared-config" {
  content = yamlencode({
    tunnel = cloudflare_argo_tunnel.auto_tunnel.id
    "credentials-file" = "/etc/cloudflared/cert.json"
    logfile = "/var/log/cloudflared.log"
    loglevel = "info"
    ingress = [
      {
        hostname = "dpw.${var.cloudflare_zone}"
        service = "http://localhost:8080"
      },
      {
        hostname = "python-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8081"
      },
      {
        hostname = "go-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8083"
      },
      {
        hostname = "nodejs-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8082"
      },
      {
        hostname = "rust-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8085"
      },
      {
        hostname = "deno-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8084"
      },
      {
        hostname = "crystal-dpw.${var.cloudflare_zone}"
        service = "http://localhost:8086"
      },
      {
        hostname = "*"
        service = "http_status:404"
      }
    ]
  })
  filename = "${path.module}/cloudflared/config.yml"
}
