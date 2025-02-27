provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "s3-bucket-ubaida-saood"
}

resource "aws_ecr_repository" "lambda_repo" {
  name = "s3-to-rds-lambda-repo"
}

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

resource "aws_glue_crawler" "s3_crawler" {
  database_name = "my_glue_db"
  name          = "s3-to-glue-crawler"
  role          = aws_iam_role.glue_role.arn
  s3_target {
    path = aws_s3_bucket.data_bucket.bucket
  }
}

resource "aws_glue_catalog_database" "glue_db" {
  name = "my_glue_db"
}

resource "aws_iam_role" "glue_role" {
  name = "glue-crawler-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "glue_policy" {
  role   = aws_iam_role.glue_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      { Effect = "Allow", Action = "s3:*", Resource = "*" },
      { Effect = "Allow", Action = "glue:*", Resource = "*" }
    ]
  })
}

resource "aws_lambda_function" "s3_to_rds_lambda" {
  function_name = "s3-to-rds-lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repo.repository_url}:latest"
  timeout       = 60

  environment {
    variables = {
      RDS_HOST     = aws_db_instance.rds.address
      RDS_USER     = "admin"
      RDS_PASSWORD = "SecurePassword123!"
      RDS_DB       = "testdb"
    }
  }
}

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
      { Effect = "Allow", Action = "glue:*", Resource = "*" },
      { Effect = "Allow", Action = "logs:*", Resource = "*" }
    ]
  })
}

output "ecr_repo_url" {
  value = aws_ecr_repository.lambda_repo.repository_url
}
