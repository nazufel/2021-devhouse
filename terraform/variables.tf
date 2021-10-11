# variables.tf


variable "DEVHOUSE_2021_GCP_PROJECT" {
  default     = ""
  description = "the project name"
}

variable "DEVHOUSE_2021_GCP_REGION" {
  default     = "us-east4"
  description = "the region to build in"
}