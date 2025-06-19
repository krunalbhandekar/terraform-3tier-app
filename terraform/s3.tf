resource "random_id" "suffix" {
  byte_length = 4
}

resource "aws_s3_bucket" "frontend" {
  bucket = "todo-frontend-${random_id.suffix.hex}"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "frontend_ownership" {
  bucket = aws_s3_bucket.frontend.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "frontend_pab" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Upload static files
resource "aws_s3_bucket_object" "frontend_files" {
  for_each = fileset("${path.module}/../frontend", "*")
  bucket   = aws_s3_bucket.frontend.id
  key      = each.value
  source   = "${path.module}/../frontend/${each.value}"

  acl = "public-read"
  content_type = lookup({
    "index.html" = "text/html"
    },
    each.value, "text/plain"
  )
}

# Dynamic config.js with API base
resource "aws_s3_bucket_object" "config_js" {
  bucket       = aws_s3_bucket.frontend.id
  key          = "config.js"
  content      = "window.API_BASE = \"https://${var.api_subdomain}.${var.root_domain}\";"
  acl          = "public-read"
  content_type = "application/javascript"
}
