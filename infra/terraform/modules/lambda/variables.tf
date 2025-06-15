variable "name" {}
variable "image_uri" {}
variable "event_schedule" { default = "rate(1 hour)" }
variable "env_vars" {
  type = map(string)
  default = {}
}