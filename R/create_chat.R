#' Create a chat object.
#'
#' @param vendor,engine A character vector with one element. 
#'   Currently, only "openai", "mistral", "anthropic" and "ollama" are supported.
#' @param api_key,key The API key for the vendor"s chat engine. 
#'   If the vendor is "ollama", this parameter is not required.
#' @param port The port number for the ollama chat engine. 
#'   Default to ollama"s standard port. If the vendor is not "ollama", this parameter is not required.
#' @param api_version,version Api version that is required for Anthropic
#' @param ... Additional parameters to be passed to the chat engine query.
#' @param object New query object from [httr2::request].
#'
#' @return A chat object
#'
#' @examples
#' \dontrun{
#' dotenv::load_dot_env()
#' chat_openai <- create_chat("openai", Sys.getenv("OAI_DEV_KEY"))
#' chat_mistral <- create_chat("mistral", Sys.getenv("MISTRAL_DEV_KEY"))
#' }
#' @export
#' @name create_chat
create_chat <- function(
  vendor = c("openai", "mistral", "ollama", "anthropic"),
  api_key = "", 
  port = if (vendor == "ollama") 11434 else NULL, 
  api_version = ""
) {
  vendor <- match.arg(vendor)

  .Deprecated(
    call,
    "tidychat",
    msg = sprintf(
      "Deprecated in favour of `new_chat_%s`",
      vendor
    )
  )

  switch(
    vendor,
    openai = new_chat_openai(api_key),
    mistral = new_chat_mistral(api_key),
    ollama = new_chat_ollama(port),
    anthropic = new_chat_anthropic(api_key, api_version)
  )
}

#' @export
print.tidychat <- function(x, ...) {
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

#' @export
#' @rdname create_chat
new_chat <- function(engine, object, ...){
  structure(
    object,
    engine = engine,
    messages = list(),
    params = list(...),
    model = NULL,
    uses = 0L,
    class = c("tidychat", engine, class(object))
  )
}

#' @export
#' @rdname create_chat
new_chat_openai <- function(key = Sys.getenv("OPENAI_API_KEY")){
  stopifnot(key != "")
  # https://platform.openai.com/docs/api-reference/making-requests
  req <- httr2::request(
    base_url = "https://api.openai.com/v1/chat/completions"
  ) |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", key),
      "Content-Type" = "application/json"
    )

  new_chat("openai", req)
}

#' @export
#' @rdname create_chat
new_chat_mistral <- function(key = Sys.getenv("MISTRAL_API_KEY")){
  stopifnot(key != "")
  # https://docs.mistral.ai/
  req <- httr2::request(
    base_url = "https://api.mistral.ai/v1/chat/completions"
  ) |>
    httr2::req_headers(
      "Authorization" = paste("Bearer", key),
      "Content-Type" = "application/json",
      "Accept" = "application/json"
    )

  new_chat("mistral", req)
}

#' @export
#' @rdname create_chat
new_chat_ollama <- function(port) {
  stopifnot(!missing(port))
  # https://docs.mistral.ai/
  req <- httr2::request(
    base_url = sprintf(
      "http://localhost:%s/api/chat",
      port
    )
  )
  
  new_chat("ollama", req, stream = FALSE)
}

#' @export
#' @rdname create_chat
new_chat_anthropic <- function(key, version){
  stopifnot(!missing(key), !missing(version))
  # https://platform.openai.com/docs/api-reference/making-requests

  req <- httr2::request(
    base_url = "https://api.anthropic.com/v1/messages"
  ) |>
    httr2::req_headers(
      "x-api-key" = key,
      "Content-Type" = "application/json",
      "anthropic-version" = version 
    )

  new_chat("anthropic", req)
}
