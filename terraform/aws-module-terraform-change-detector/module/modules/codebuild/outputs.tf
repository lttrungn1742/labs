output codebuild_project_id { value = aws_codebuild_project.this.id }
output codebuild_webhook_id { value = aws_codebuild_webhook.this.*.id }
output codebuild_webhook { value = aws_codebuild_webhook.this.* }
output "codebuild_project_arn" {
  value = aws_codebuild_project.this.arn
}