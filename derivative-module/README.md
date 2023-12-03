# derivative-module

modules derivatived from others

```terraform
module "derivative_module" {
  source = "github.com/linolabx/terraform-modules-meta//derivative-module"

  module_path = "${path.module}/../modules/cloudflare-${local.account_id}"

  readme = <<EOF
# Cloudflare

${local.account_id}

## Usage

```tf
module "cloudflare" { source = "git::ssh://git@github.com:<org>/<repo>.git//modules/cloudflare-${local.account_id}" }
provider "cloudflare" {
  email   = module.cloudflare.auth.email
  api_key = module.cloudflare.auth.api_key
}

# module.cloudflare.auth.account_id
# module.cloudflare.zone.example_com
```
EOF

  files = {
    "main.tf" = <<EOF
data "vault_kv_secret_v2" "cloudflare" {
  mount = "${var.vault_mount}"
  name  = "manual/cf-<account-id>"
}

output "auth" { value = {
  email      = data.vault_kv_secret_v2.cloudflare.data["email"]
  api_key    = data.vault_kv_secret_v2.cloudflare.data["api_key"]
  account_id = data.vault_kv_secret_v2.cloudflare.data["account_id"] 
} }
EOF
  }

  outputs = local.output
}

```
