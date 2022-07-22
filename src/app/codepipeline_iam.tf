resource "aws_iam_role" "codepipeline_role" {
  name = "${var.name}-codepipeline-role"

  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${var.name}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = data.aws_iam_policy_document.codepipeline_policy.json
}

data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    sid = "AllowRegisterTaskDefinition"
    actions = [
      "ecs:RegisterTaskDefinition"
    ]
    resources = ["*"]
  }

  statement {
    sid = "AllowECS"
    actions = [
      "ecs:UpdateService",
      "ecs:DescribeServices"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid = "AllowIAMPassRole"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"
    ]
  }

  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObjectAcl",
      "s3:PutObject"
    ]

    resources = [
      "${aws_s3_bucket.codepipeline_bucket.arn}",
      "${aws_s3_bucket.codepipeline_bucket.arn}/*"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]

    resources = [
      aws_codebuild_project.main.arn,
    ]
  }

  statement {
    sid = "AllowCodeDeploy"

    actions = [
      "codedeploy:BatchGetApplications",
      "codedeploy:BatchGetDeploymentGroups",
      "codedeploy:BatchGetDeployments",
      "codedeploy:CreateApplication",
      "codedeploy:CreateDeployment",
      "codedeploy:CreateDeploymentConfig",
      "codedeploy:CreateDeploymentGroup",
      "codedeploy:DeleteApplication",
      "codedeploy:DeleteDeploymentConfig",
      "codedeploy:DeleteDeploymentGroup",
      "codedeploy:Get*",
      "codedeploy:List*",
      "codedeploy:RegisterApplicationRevision",
      "codedeploy:TagResource",
      "codedeploy:UntagResource",
      "codedeploy:UpdateApplication",
      "codedeploy:UpdateDeploymentGroup",
    ]

    resources = [
      "arn:aws:codedeploy:*:${data.aws_caller_identity.current.account_id}:application:*",
      "arn:aws:codedeploy:*:${data.aws_caller_identity.current.account_id}:deploymentgroup:*",
      "arn:aws:codedeploy:*:${data.aws_caller_identity.current.account_id}:deploymentconfig:*"
    ]
  }

  statement {
    sid = "AllowGlobalCodeDeploy"

    actions = [
      "codedeploy:StopDeployment",
      "codedeploy:ListDeploymentConfigs",
      "codedeploy:ListDeploymentTargets",
      "codedeploy:ListApplications"
    ]

    resources = ["*"]
  }

  statement {
    sid = "AllowCodestarConnection"

    actions = [
      "codestar-connections:UseConnection"
    ]

    resources = [
      var.github_connection.arn
    ]
  }
}
