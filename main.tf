provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-bucket"
  acl    = "private"  # Make the bucket private

  tags = {
    Name        = "My Secure S3 Bucket"
    Environment = "Prod"
  }
}

resource "aws_s3_bucket_policy" "secure_bucket_policy" {
  bucket = aws_s3_bucket.secure_bucket.bucket

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::123456789012:role/MyTrustedRole"  # Restrict to specific AWS principal
        }
        Action = "s3:GetObject"
        Resource = "${aws_s3_bucket.secure_bucket.arn}/*"
      }
    ]
  })
}
