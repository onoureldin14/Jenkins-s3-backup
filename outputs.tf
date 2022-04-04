output "access_key" {
  value = aws_iam_access_key.s3-user-access-key.id
}

output "secret-access-key-base64" {
  value = aws_iam_access_key.s3-user-access-key.encrypted_secret
  description = "Encrypted by a Keybase Key"
}

output "s3-bucket-arn" {
  value = aws_s3_bucket.mysql-backup-bucket.arn
}
