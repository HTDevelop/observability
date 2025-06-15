variable "region" {
  default = "ap-northeast-1"
}

variable "account_id" {
  default = "082032435474"
}

variable "k6_prometheus_rw_sigv4_access_key" {
  description = "Access Key for Prometheus SigV4"
  type        = string
  sensitive   = true
}

variable "k6_prometheus_rw_sigv4_secret_key" {
  description = "Secret Key for Prometheus SigV4"
  type        = string
  sensitive   = true
}

variable "k6_prometheus_rw_sigv4_region" {
  description = "Region for SigV4 signing"
  type        = string
  default     = "ap-northeast-1"
}

variable "k6_prometheus_rw_server_url" {
  description = "Remote Write URL for AMP"
  type        = string
  default = "https://aps-workspaces.ap-northeast-1.amazonaws.com/workspaces/ws-e6b14789-a6b2-4f60-b7dd-b11cafdaf5ad/api/v1/remote_write"
}