resource "azurerm_app_service_plan" "asp" {
  name                = "${var.name}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    tier = var.sku_tier
    size = var.sku_size
  }

  kind = "Linux"
  reserved = true
}

resource "azurerm_linux_web_app" "web" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = azurerm_app_service_plan.asp.id
  # A minimal site_config block is required by the provider. We leave it empty
  # to avoid setting `linux_fx_version` here (some provider versions mark that
  # attribute as computed/read-only during planning). If you need a specific
  # runtime, consider using a container via `linux_fx_version = "DOCKER|<image>"`
  # or configure the runtime via the Portal / CI pipeline after provisioning.
  site_config {
    # intentionally left blank
  }

  app_settings = merge({
    "WEBSITE_RUN_FROM_PACKAGE" = "1"
  }, var.app_settings)

  identity {
    type = "SystemAssigned"
  }
}