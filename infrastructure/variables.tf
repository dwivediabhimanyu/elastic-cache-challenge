variable "namespace" {
  description = "Namespace is used for unique resource naming"
  default     = "june-challenge"
  type        = string
}

variable "region" {
  description = "AWS region for resources"
  default     = "ap-south-1"
  type        = string
}
