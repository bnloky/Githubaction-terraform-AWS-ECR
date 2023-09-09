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

resource "aws_ecr_repository" "Ecr-Repository" {
  name = "Push the dockerImage to ECR"
}

data "aws_iam_policy_document" "aws_ecr_repo_policy_doc" {
  statement {
    sid    = "new policy"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["681217613251"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
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

resource "aws_ecr_repository_policy" "aws-ecr-rep-policy" {
  repository = aws_ecr_repository.Ecr-Repository.name
  policy     = data.aws_iam_policy_document.aws_ecr_repository_policy.json
}