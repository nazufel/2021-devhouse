# variables.tf

# file to hold variables for terraform

# --------------------------------------------------------------------------- #

# init variable for project name
variable "DEVHOUSE_2021_GCP_PROJECT" {
  default     = ""
  description = "the project name"
}

# init variable for app region
variable "DEVHOUSE_2021_GCP_REGION" {
  default     = "us-east4"
  description = "the region to build in"
}
#EOF