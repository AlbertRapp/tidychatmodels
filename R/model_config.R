config_list_azure <- function(
    api_key = Sys.getenv("AZURE_OPENAI_KEY"),
    endpoint = Sys.getenv("AZURE_OPENAI_ENDPOINT"),
    api_version = Sys.getenv("AZURE_OPENAI_API_VERSION"),
    model = Sys.getenv("AZURE_OPENAI_DEPLOYMENT_NAME"),
    task = Sys.getenv("AZURE_OPENAI_TASK"),
    use_token = Sys.getenv("AZURE_OPENAI_USE_TOKEN"),
    tenant_id = Sys.getenv("AZURE_OPENAI_TENANT_ID"),
    client_id = Sys.getenv("AZURE_OPENAI_CLIENT_ID"),
    client_secret = Sys.getenv("AZURE_OPENAI_CLIENT_SECRET")
) {
  list(
    api_key = api_key,
    endpoint = endpoint,
    api_version = api_version,
    model = model,
    task = task,
    use_token = use_token,
    tenant_id = tenant_id,
    client_id = client_id,
    client_secret = client_secret
  )
}


retrieve_azure_token <- function(tenant_id, client_id, client_secret) {
  rlang::check_installed("AzureRMR")

  token <-
    try(
      AzureRMR::get_azure_login(
        tenant = tenant_id,
        app = client_id,
        scopes = ".default",
        auth_type = "client_credentials"
      )
    )

  if (inherits(token, "try-error")) {
    token <- AzureRMR::create_azure_login(
      tenant = tenant_id,
      app = client_id,
      password = client_secret,
      host = "https://cognitiveservices.azure.com/",
      scopes = ".default"
    )
  }
  invisible(token$token$credentials$access_token)
}
