resource "aws_s3_bucket" "Website" {
  bucket = var.myfirstwebsite

  tags = {
    Name = var.myfirstwebsite-tag
    Environment = "Dev"
  }

}

resource "aws_s3_bucket_website_configuration" "Website" {
  bucket = aws_s3_bucket.Website.bucket

  index_document {
    suffix = "readme.html"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.Website.id
  versioning_configuration {
    status = "Enabled"

  }
}

resource "aws_iam_user" "DemoUser" {
  name = "DemoUser"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.Website.bucket
  key    = "readme.html"
  source = "C:/repos/readme.html"  # Replace with the path to your index.html file
}

resource "aws_s3_bucket_public_access_block" "enablepublicaccess" {
  bucket = aws_s3_bucket.Website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_iam_user_policy_attachment" "assignroletouser" {
  user       = aws_iam_user.DemoUser.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"  # Update with the ARN of the policy you want to attach
}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
    bucket = aws_s3_bucket.Website.id
    policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Principal = "*"
                Action = "s3:GetObject"
                Resource = "${aws_s3_bucket.Website.arn}/*"
            }
        ]
    })
}