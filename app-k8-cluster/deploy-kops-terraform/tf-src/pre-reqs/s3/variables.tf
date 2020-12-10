variable "bucket_name" {}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = map(string)
}

variable "sse_allgorithm" {
  default = "ASE256"
}

variable "s3_force_destroy" {
  default = false
}