variable "sg_organization" {
  type        = string
  description = "StackGuardian Organization name"
  nullable    = false
}

variable "sg_workflow_group" {
  type        = string
  description = "StackGuardian Workflow Group name"
  nullable    = false
}
variable "workspace_id" {
  type        = string
  description = "meshcloud Customer ID"
  nullable    = false
}
variable "project_id" {
  type        = string
  description = "meshcloud Project ID"
  nullable    = false
}
variable "account" {
  type = string
  description = "Account ID of the Azure Subscription"
  nullable = false
}
variable "size" {
  type = number
  description = "Subnetmask of the VPC"
  nullable = false
}
variable "description" {
    type = string
    description = "Short description for the VPC"
    nullable = false
}
variable "gateway" {
    type = string
    description = "AWS Instance Type for the GW"
    nullable = false
}