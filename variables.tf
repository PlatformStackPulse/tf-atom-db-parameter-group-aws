variable "family" {
  description = "DB parameter group family (e.g., postgres16)"
  type        = string
  validation {
    condition     = length(var.family) > 0
    error_message = "family must not be empty."
  }
}

variable "parameters" {
  description = "List of DB parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string, "immediate")
  }))
  default = []
}

variable "description" {
  description = "Description of the parameter group"
  type        = string
  default     = null
}
