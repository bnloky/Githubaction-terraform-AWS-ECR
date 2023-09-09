provider "aws"  {
region = "ap-south-1"
}

terraform {
  backend "s3" {
    bucket = "terraformbackedstatefilestore"
    key    = "tffiles.tfstate"
    region = "ap-south-1"
  }
}

resource "aws_lambda_function" "my_function" {
    role = "arn:aws:iam::681217613251:role/My_Lambda_Function"
    function_name = "my_lambda_function"
    runtime = "python3.8"
    handler = "index.handler"
    timeout = 300
    filename = data.archive_file.lambda_function_archive.output_path
    source_code_hash = filebase64sha256(data.archive_file.lambda_function_archive.output_path)
}

data "archive_file" "lambda_function_archive" {
  type        = "zip"
  source_dir  =  "./lambdafunction"  # Path to the directory containing your Lambda function code
  output_path = "./lambdafunction.zip"   # Path where you want to save the generated zip archive
}