resource "aws_iam_user" "s3-user" {
  name = "s3-access-user"
}

resource "aws_iam_access_key" "s3-user-access-key" {
  user = aws_iam_user.s3-user.name
  pgp_key = "keybase:onoureldin_"
  }

resource "aws_iam_user_policy" "s3-full-access" {
  name = "s3-full-access"
  user = aws_iam_user.s3-user.name


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:*",
                "s3-object-lambda:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}