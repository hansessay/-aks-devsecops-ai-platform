variable "enabled" {
  description = "Whether to install Kubecost."
  type        = bool
  default     = false
}

variable "namespace" {
  description = "Namespace for Kubecost."
  type        = string
  default     = "kubecost"
}
