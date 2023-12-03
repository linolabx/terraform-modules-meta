variable "module_path" {
  type        = string
  description = "The local filesystem path stores this module"
}

variable "readme" {
  type        = string
  description = "The README.md template of the module, '## Data' paragraph will be appended to the end of the file with the outputs of the module"
}

variable "files" {
  type        = map(string)
  description = "The files to be set in the module"
}

variable "outputs" {
  type        = any
  description = "The outputs value of the module"
}

resource "local_file" "outputs" {
  filename = "${var.module_path}/outputs.tf.json"
  content  = jsonencode({ output = [for k, v in var.outputs : { "${k}" = { value = v } }] })
}

resource "local_file" "readme" {
  filename = "${var.module_path}/README.md"
  content  = <<EOF
${var.readme}

## Data

```yaml
${yamlencode(var.outputs)}
```
EOF
}

resource "local_file" "files" {
  for_each = var.files
  filename = "${var.module_path}/${each.key}"
  content  = each.value
}
