### Global Variables
variable application_code {
  description = "Código de aplicación a desplegar."
  type        = string
}

variable resource_correlative {
  description = "Especifica el número correlativo asignado al recurso."
  type        = string
  default     = "01"
}

variable base_correlative {
  description = "Especifica el numero correlativo asignado a la infraestructura base."
  type        = string
  default     = "01"
}

variable environment {
  description = "Especifica el ambiente en el que se desplegará la aplicación."
  type        = string
}

variable container_type {
  description = "Especifica el numero correlativo asignado a la infraestructura base."
  type        = string
  default     = "docker"
}

variable location {
  description = "Código de la región a desplegar."
  type        = list(string)
}

### Private Variables
variable azfd_session_affinity {
  description = "Permite dirigir el tráfico subsiguiente de una sesión de usuario al mismo backend de la aplicación."
  type        = bool
  default     = false
}

variable azfd_backend {
  description = "Variables para backend: host_name, host_header, http_port, https_port, priority, weight"
  type = list(object({
    host_name   = string
    host_header = string
    http_port   = string
    https_port  = string
    priority    = string
    weight      = string
  }))
}

locals {
  azfd_code                  = "azfd"
  rsgr_code                  = "rsgr"
  azfd_name                  = lower(format("%s%s%s%s%s", local.azfd_code, var.location[0], var.application_code, var.environment, var.resource_correlative))
  rsgr_name                  = upper(format("%s%s%s%s%s", local.rsgr_code, var.location[0], var.application_code, var.environment, var.base_correlative))
  azfd_frontend_name         = format("%s%s", local.azfd_name, ".azurefd.net")
  backend_pool_name          = format("%s%s", local.azfd_name, "-BackendPool")
  load_balancing_name        = format("%s%s", local.azfd_name, "-LoadBalancingSettings")
  health_probe_name          = format("%s%s", local.azfd_name, "-HealthProbeSetting")
  routing_rule_name          = format("%s%s", local.azfd_name, "-RoutingRule")
  forwarding_protocol_code   = "HttpsOnly"
  health_probe_protocol_code = "Https"
}
