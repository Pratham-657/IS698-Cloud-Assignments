output "instance_id" {
  value = aws_instance.web.id
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.profile.name
}
