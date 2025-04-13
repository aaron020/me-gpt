# Moves layer to pre build folder if there is any changes
resource "null_resource" "prepare_layer" {
  triggers = {
    source_dir_hash = sha256(join("", [for f in fileset("${path.module}/../../src/python", "**") : filesha256("${path.module}/../../src/python/${f}")]))
  }

  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ${path.module}/pre-build/layer/python
      cp -r ${path.module}/../../src/python/* ${path.module}/pre-build/layer/python/
    EOT
  }
}

# Converts layer to zip and moves to build folder
data "archive_file" "layer_zip" {
  type = "zip"

  source_dir  = "${path.module}/pre-build/layer"
  output_path = "${path.module}/build/common-layer.zip"

  depends_on = [null_resource.prepare_layer]
}

# Layer
resource "aws_lambda_layer_version" "common_layer" {
  depends_on          = [data.archive_file.layer_zip]
  layer_name          = "chat-app-common-layer"
  description         = "Chat app common layer"
  filename            = "${path.module}/build/common-layer.zip"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = data.archive_file.layer_zip.output_base64sha256
}

# Layer - anthropic
resource "aws_lambda_layer_version" "anthropic_layer_v7" {
  layer_name          = "anthropic-layer-v7"
  description         = "Build of anthropic api"
  filename            = "${path.module}/build/anthropic-layer.zip"
  compatible_runtimes = ["python3.11"]
  source_code_hash    = data.archive_file.layer_zip.output_base64sha256
}