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

resource "aws_ecr_repository" "ecr_repo" {
  name = "deploy-aws-lambda-ecr-image"
}

data "aws_iam_policy_document" "ecr_repo_policy_doc" {
  statement {
    sid    = "deploy aws lambda ecr image policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.account_id]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

resource "aws_ecr_repository_policy" "ecr_repo_policy" {
  repository = aws_ecr_repository.ecr_repo.name
  policy     = data.aws_iam_policy_document.ecr_repo_policy_doc.json
}