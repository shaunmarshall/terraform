
# Create the AWS IAM role. 
resource "aws_iam_role" "ec2_role" {
  name = "${var.deployment_name}_ec2_iam_role_name"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# Create AWS IAM instance profile
# Attach the role to the instance profile
resource "aws_iam_instance_profile" "this" {
  name = "${var.deployment_name}_ec2_iam_role_name"
  role = aws_iam_role.ec2_role.name
}

# Create a policy for the role
resource "aws_iam_policy" "s3_access" {
  name        = "${var.deployment_name}_s3_policy"
  path        = "/"
  description = "Ec2 access to s3"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject"
            ],
            "Resource": [
                "arn:aws:s3:::${var.s3_bucket_name}/*"
            ]
        }
    ]
})
}

resource "aws_iam_policy" "cloudwatch" {
  name        = "${var.deployment_name}_cloudwatch_policy"
  path        = "/"
  description = "Ec2 access Cloudwatch"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics",
        "cloudwatch:PutMetricData",
        "ec2:DescribeTags",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:DescribeLogStreams",
        "logs:PutSubscriptionFilter",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:*:*:*"
      ]
    }
  ]
})
}


# Attaches the policies to the IAM role
resource "aws_iam_policy_attachment" "ec2_role" {
  name       = "${var.deployment_name}_ec2_iam_role_name"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_policy_attachment" "ec2_role_cloudwatch" {
  name       = "${var.deployment_name}_ec2_iam_role_name"
  roles      = [aws_iam_role.ec2_role.name]
  policy_arn = aws_iam_policy.cloudwatch.arn
}
