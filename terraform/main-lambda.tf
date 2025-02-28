# Lambda Function (depends on the image being built and pushed)
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
