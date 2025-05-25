variable "jenkins_url" {
  description = "Jenkins job webhook URL (with token)"
  type        = string
}

variable "lambda_bucket" {
  description = "S3 bucket name for Lambda zip upload"
  type        = string
}