resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = var.acl

  tags =  var.tags
  force_destroy = var.s3_force_destroy
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm =  var.sse_allgorithm
      }
    }
  }

}