provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-s3-bucket-20250227-tushar-123"
}

# ECR Repository
resource "aws_ecr_repository" "lambda_repo" {
  name = "s3-to-rds-lambda-repo"
}

# RDS Instance
resource "aws_db_instance" "rds" {
  identifier          = "my-rds-instance"
  engine             = "mysql"
  engine_version     = "8.0"
  instance_class     = "db.t3.micro"
  allocated_storage  = 20
  username           = "admin"
  password           = "SecurePassword123!"
  skip_final_snapshot = true
  publicly_accessible = true
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_role" {
  name = "lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  role   = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = "s3:*", Resource = "*" },
      { Effect = "Allow", Action = "logs:*", Resource = "*" }
    ]
  })
}

# Output ECR Repository URL for the pipeline
output "ecr_repo_url" {
  value = aws_ecr_repository.lambda_repo.repository_url
}
