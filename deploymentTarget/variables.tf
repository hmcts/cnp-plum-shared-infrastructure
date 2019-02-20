
//SHARED VARIABLES
variable "subscription" {}

variable "product" {
  type        = "string"
  description = "The name of your application"
  default     = "plum"
}

variable "env" {
  type        = "string"
  description = "The deployment environment (sandbox, aat, prod etc..)"
}

variable "location" {
  type        = "string"
  description = "The location where you would like to deploy your infrastructure"
  default     = "UK South"
}

variable "team_contact" {
  type        = "string"
  description = "The name of your Slack channel people can use to contact your team about your infrastructure"
  default     = "#Cloud-Native"
}

// ASP SPECIFIC VARIABLES
variable "asp_capacity" {
  type    = "string"
  default = "2"
}

variable "certificate_name" {
  type = "string"
  default = "STAR-platform-hmcts-net"
  description = "The certificate name to use in public listeners. Should support the public hostname."
}

variable "public_hostname" {
  type = "string"
  default = "plum.platform.hmcts.net"
  description = "The public hostanme to use when accessing plum's frontend"
}

variable "health_check_interval" {
  default     = "60"
  description = "interval between healthchecks in seconds"
}

variable "unhealthy_threshold" {
  default     = "3"
  description = "unhealthy threshold applied to healthprobe"
}

variable "health_check" {
  default     = "/health"
  description = "endpoint for healthcheck"
}


variable "infra_location" {
  type    = "string"
  default = "env-infra"
}
variable "common_tags" {
  type = "map"
}

variable deployment_target {
}