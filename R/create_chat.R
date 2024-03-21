#' Create a chat object.
#'
#' @param vendor A character vector with one element. Currently, only 'openai', 'mistral', 'anthropic' and 'ollama' are supported.
#' @param api_key The API key for the vendor's chat engine. If the vendor is 'ollama', this parameter is not required.
#' @param port The port number for the ollama chat engine. Default to ollama's standard port. If the vendor is not 'ollama', this parameter is not required.
#' @param api_version Api version that is required for Anthropic
#' @param options A list of additional options that can be passed to the chat engine. Currently used for Azure OpenAI service only.
#'
#' @return A chat object
#' @export
#'
#' @examples
#' \dontrun{
#' dotenv::load_dot_env()
#' chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))
#' chat_mistral <- create_chat('mistral', Sys.getenv('MISTRAL_DEV_KEY'))
#' }
create_chat <- function(vendor, api_key = '', port = if (vendor == 'ollama') 11434 else NULL, api_version = '', options = NULL) {

  rlang::arg_match(vendor, c('openai', 'mistral', 'ollama', 'anthropic', 'azure'))

  if (vendor == 'openai') {
    # https://platform.openai.com/docs/api-reference/making-requests
    engine <- httr2::request(
      base_url ='https://api.openai.com/v1/chat/completions'
    ) |>
      httr2::req_headers(
        'Authorization' = paste('Bearer', api_key),
        'Content-Type' = 'application/json'
      )
  }

  if (vendor == 'mistral') {
    # https://docs.mistral.ai/
    engine <- httr2::request(
      base_url ='https://api.mistral.ai/v1/chat/completions'
    ) |>
      httr2::req_headers(
        'Authorization' = paste('Bearer', api_key),
        'Content-Type' = 'application/json',
        'Accept' = 'application/json'
      )
  }

  if (vendor == 'ollama') {
    # https://docs.mistral.ai/
    engine <- httr2::request(
      base_url = glue::glue(
        'http://localhost:{port}/api/chat'
      )
    )
  }

  if (vendor == 'anthropic') {
    # https://platform.openai.com/docs/api-reference/making-requests
    if (api_version == '') stop('Anthropic requires API version')

    engine <- httr2::request(
      base_url ='https://api.anthropic.com/v1/messages'
    ) |>
      httr2::req_headers(
        'x-api-key' = api_key,
        'Content-Type' = 'application/json',
        'anthropic-version' = api_version
      )
  }

  if (vendor == 'azure') {
    if (is.null(options)) options <- config_list_azure()
    engine <- httr2::request(
      base_url = options$endpoint
    ) |>
      httr2::req_url_path_append("openai/deployments") |>
      httr2::req_url_path_append(options$model) |>
      httr2::req_url_path_append(options$task) |>
      httr2::req_url_query("api-version" = options$api_version) |>
      httr2::req_headers("api-key" = options$api_key)
    if (rlang::is_true(as.logical(options$use_token))) {
      cli::cli_inform("Fetching Azure token")
      token <- retrieve_azure_token(tenant_id     = options$tenant_id,
                                    client_id     = options$client_id,
                                    client_secret = options$client_secret)
      engine <- engine |>
        httr2::req_auth_bearer_token(token = token)
    }
  }

  if (vendor == 'ollama') {
    chat <- list(
      vendor_name = vendor,
      engine = engine,
      messages = list(),
      params = list(stream = FALSE)
    )
  }

  if (vendor != 'ollama') {
    chat <- list(
      vendor_name = vendor,
      engine = engine,
      messages = list()
    )
  }
  class(chat) <- 'chat'
  return(chat)
}

#' @export
print.chat <- function(x, ...) {
  cli::cli_div(
    theme = list(
      span.param = list(color = "blue")
    )
  )

  cli::cli_text("{.field Chat Engine}: {x$vendor_name}")
  cli::cli_text("{.field Messages}: {length(x$messages)}")
  if (length(x$model) > 0) cli::cli_text("{.field Model}: {x$model}")
  if (length(x$params) > 0) {
    cli::cli_text("{.field Parameters}:")
    ul <- cli::cli_ul()
    for (param in names(x$params)) {
      cli::cli_li("{.param {param}}: {x$params[[param]]}")
    }
    cli::cli_end(ul)
  }
}

#' @keywords internal
#' @noRd
knit_print.chat <- function(x, ...) {
  knitr::knit_print(x, ...)
}
