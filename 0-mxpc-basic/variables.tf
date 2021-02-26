# credentials ---------------------------------------------------------
variable "principalAppId" {
    type = string
    description = "your azure principal id"
}

variable "principalAppSecret" {
    type = string
    description = "your azure principal secret"
}


# azure ---------------------------------------------------------------
variable "prefix" {
    type = string
    description = "a unqiue prefix to prevent naming conflicts"
    validation {
        condition     = length(var.prefix) <= 16
        error_message = "Prefix must less than 16 characters to generate acceptable DNS names for storage, db etc."
    }
}

variable "location" {
    type = string
    description = "azure location to provision this sample in"
}


# aks -----------------------------------------------------------------
variable "aksnodecount" {
    type = number
    default = 1
    description = "(optional) number of nodes in the aks cluster"
}

variable "aksvmsize" {
    type = string
    default = "Standard_B2s"
    description = "(optional) size of aks node vms"
}


# ms sql server -------------------------------------------------------
variable "mssqlserveradmin_username" {
    type = string
    description = "admin username for ms sql server"
}

variable "mssqlserveradmin_password" {
    type = string
    description = "admin password for ms sql server"
}