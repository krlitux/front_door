resource "azurerm_frontdoor" "azfd" {
  name                                         = local.azfd_name
  resource_group_name                          = local.rsgr_name
  enforce_backend_pools_certificate_name_check = false

  routing_rule {
    name               = local.routing_rule_name
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [local.azfd_name]
    forwarding_configuration {
      forwarding_protocol = local.forwarding_protocol_code
      backend_pool_name   = local.backend_pool_name
    }
  }

  backend_pool_load_balancing {
    name                            = local.load_balancing_name
    additional_latency_milliseconds = var.azfd_backend_latency
  }

  backend_pool_health_probe {
    name     = local.health_probe_name
    protocol = local.health_probe_protocol_code
  }

  backend_pool {
    name = local.backend_pool_name
    dynamic backend {
      for_each = var.azfd_backend
      content {
        host_header = backend.value.host_header
        address     = backend.value.host_name
        http_port   = backend.value.http_port
        https_port  = backend.value.https_port
        priority    = backend.value.priority
        weight      = backend.value.weight
      }
    }

    load_balancing_name = local.load_balancing_name
    health_probe_name   = local.health_probe_name
  }

  frontend_endpoint {
    name                              = local.azfd_name
    host_name                         = local.azfd_frontend_name
    session_affinity_enabled          = var.azfd_session_affinity
    custom_https_provisioning_enabled = false
  }
}
