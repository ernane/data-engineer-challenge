resource "aws_glue_job" "users_job" {
  name              = "users_job"
  role_arn          = aws_iam_role.ejjunior.arn
  glue_version      = "2.0"
  number_of_workers = 10
  worker_type       = "G.1X"
  command {
    script_location = "s3://ejjunior/jobs/users_job.py"
  }
  default_arguments = {
    "--job-language" = "python"
    "--TempDir"      = "s3://ejjunior/temp"
  }
}