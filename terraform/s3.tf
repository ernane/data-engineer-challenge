data "aws_s3_bucket" "data" {
  bucket = "ejjunior"
}

resource "aws_s3_bucket_object" "config" {
  bucket = data.aws_s3_bucket.data.id
  key    = "config/"
  tags   = var.tags
}

resource "aws_s3_bucket_object" "jobs" {
  bucket = data.aws_s3_bucket.data.id
  key    = "jobs/"
  tags   = var.tags
}

resource "aws_s3_bucket_object" "temp" {
  bucket = data.aws_s3_bucket.data.id
  key    = "temp/"
  tags   = var.tags
}

resource "aws_s3_bucket_object" "input" {
  bucket = data.aws_s3_bucket.data.id
  key    = "input/users/"
  tags   = var.tags
}

resource "aws_s3_bucket_object" "output" {
  bucket = data.aws_s3_bucket.data.id
  key    = "output/users/"
  tags   = var.tags
}

resource "aws_s3_bucket_object" "types_mapping" {
  bucket = data.aws_s3_bucket.data.id
  source = "../config/types_mapping.json"
  key    = "config/types_mapping.json"
  etag   = filemd5("../config/types_mapping.json")
}

resource "aws_s3_bucket_object" "load" {
  bucket = data.aws_s3_bucket.data.id
  source = "../data/input/users/load.csv"
  key    = "input/users/load.csv"
  etag   = filemd5("../data/input/users/load.csv")
}

resource "aws_s3_bucket_object" "users_job" {
  bucket = data.aws_s3_bucket.data.id
  source = "../jobs/users_job.py"
  key    = "jobs/users_job.py"
  etag   = filemd5("../jobs/users_job.py")
}

