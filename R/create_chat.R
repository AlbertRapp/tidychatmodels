#' Create a chat object.
#'
#' @param vendor A character vector with one element. Currently, only 'openai' and 'mistral' are supported.
#' @param api_key The API key for the vendor's chat engine.
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
create_chat <- function(vendor, api_key) {
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

  chat <- list(
    vendor_name = vendor,
    engine = engine,
    messages = list()
  )
  class(chat) <- 'chat'
  return(chat)
}

print.chat <- function(chat_obj) {
  cat(crayon::green("Chat Engine:"), chat_obj$vendor_name, "\n")
  cat(crayon::green("Messages:"), length(chat_obj$messages), "\n")
  if (length(chat_obj$model) > 0) cat(crayon::green("Model:"), chat_obj$model, "\n")
  if (length(chat_obj$params) > 0) {
    cat(crayon::green("Parameters:"), "\n")
    for (param in names(chat_obj$params)) {
      cat(crayon::blue("  ", param, ":"), chat_obj$params[[param]], "\n")
    }
  }
}
