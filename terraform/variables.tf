variable "region" {
  default     = "us-east-1"
  type        = string
  description = "Default region AWS"
}

variable "tags" {
  default = {
    Environment = "development"
    Project     = "Data Engineer Challenge"
    Author      = "ernane.sena@gmail.com"
  }
  type        = map(string)
  description = "Extra tags to attach to AWS resources"
}