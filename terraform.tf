terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    load_config_file = true
  }


  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "2.20.0"
    }

  }
}
