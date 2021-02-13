variable "client_id" {}
variable "client_secret" {}
variable "ssh_public_key" {}

variable "agent_count" {
  default = 1
}

variable "dns_prefix" {
  default = "zerok8s"
}

variable cluster_name {
  default = "zeroakscluster-terraform"
}

variable resource_group_name {
  default = "zero-aks-terraform-rg"
}

variable location {
  default = "Korea Central"
}
