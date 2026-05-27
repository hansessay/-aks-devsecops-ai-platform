resource "azurerm_network_ddos_protection_plan" "ddos" {
  name                = "${var.name}-ddos"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_cdn_frontdoor_profile" "fd_profile" {
  name                = "${var.name}-fd-profile"
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
}

resource "azurerm_cdn_frontdoor_endpoint" "endpoint" {
  name                     = "${var.name}-endpoint"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  enabled                  = true
  tags = {
    environment = var.environment
    component   = "edge"
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "origin_group" {
  name                     = "${var.name}-origin-group"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  load_balancing {
    additional_latency_in_milliseconds = 0
    sample_size                        = 4
    successful_samples_required        = 2
  }

  health_probe {
    path                = var.origin_health_probe_path
    request_type        = "GET"
    protocol            = var.origin_health_probe_protocol
    interval_in_seconds = 120
  }
}

resource "azurerm_cdn_frontdoor_origin" "origin" {
  name                          = "${var.name}-origin"
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.origin_group.id
  enabled                       = true

  host_name                      = var.origin_host_name
  origin_host_header             = coalesce(var.origin_host_header, var.origin_host_name)
  http_port                      = var.origin_http_port
  https_port                     = var.origin_https_port
  certificate_name_check_enabled = false

  priority = 1
  weight   = 100
}

resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  name                              = "${var.name}-waf"
  resource_group_name               = var.resource_group_name
  sku_name                          = azurerm_cdn_frontdoor_profile.fd_profile.sku_name
  enabled                           = true
  mode                              = "Prevention"
  redirect_url                      = "https://www.${var.origin_host_name}"
  custom_block_response_status_code = 403
  custom_block_response_body        = base64encode("<html><body><h1>Request blocked by Azure Front Door WAF</h1></body></html>")

  managed_rule {
    type    = "DefaultRuleSet"
    version = "1.0"
    action  = "Log"
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "security" {
  name                     = "${var.name}-security"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.endpoint.id
        }

        patterns_to_match = ["/*"]
      }
    }
  }
}

resource "azurerm_cdn_frontdoor_rule_set" "worker_rules" {
  name                     = "${var.name}-workers"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
}

resource "azurerm_cdn_frontdoor_rule" "worker" {
  depends_on = [
    azurerm_cdn_frontdoor_origin_group.origin_group,
    azurerm_cdn_frontdoor_origin.origin,
  ]

  name                      = "${var.name}-worker-rule"
  cdn_frontdoor_rule_set_id = azurerm_cdn_frontdoor_rule_set.worker_rules.id
  order                     = 1
  behavior_on_match         = "Continue"

  actions {
    request_header_action {
      header_action = "Overwrite"
      header_name   = "X-Edge-Worker"
      value         = "AzureFrontDoor-Worker"
    }

    response_header_action {
      header_action = "Overwrite"
      header_name   = "X-Edge-Worker"
      value         = "AzureFrontDoor-Worker"
    }
  }

  conditions {
    url_path_condition {
      operator         = "BeginsWith"
      negate_condition = false
      match_values     = ["/"]
      transforms       = ["Lowercase", "Trim"]
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "custom" {
  count                    = var.custom_domain_host_name != null ? 1 : 0
  name                     = "${var.name}-custom-domain"
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.fd_profile.id
  host_name                = var.custom_domain_host_name

  tls {
    certificate_type = "ManagedCertificate"
    minimum_version  = "TLS12"
  }
}

resource "azurerm_cdn_frontdoor_route" "route" {
  name                            = "${var.name}-route"
  cdn_frontdoor_endpoint_id       = azurerm_cdn_frontdoor_endpoint.endpoint.id
  cdn_frontdoor_origin_group_id   = azurerm_cdn_frontdoor_origin_group.origin_group.id
  cdn_frontdoor_origin_ids        = [azurerm_cdn_frontdoor_origin.origin.id]
  cdn_frontdoor_rule_set_ids      = [azurerm_cdn_frontdoor_rule_set.worker_rules.id]
  cdn_frontdoor_custom_domain_ids = var.custom_domain_host_name != null ? [azurerm_cdn_frontdoor_custom_domain.custom[0].id] : []

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = var.forwarding_protocol
  https_redirect_enabled = true
  enabled                = true

  cache {
    query_string_caching_behavior = "IgnoreQueryString"
    compression_enabled           = true
    content_types_to_compress = [
      "text/html",
      "application/javascript",
      "application/json",
      "text/css",
      "image/svg+xml",
    ]
  }
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "custom_association" {
  count                          = var.custom_domain_host_name != null ? 1 : 0
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.custom[0].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.route.id]
}
