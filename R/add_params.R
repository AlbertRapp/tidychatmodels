#' Add a model to a chat object.
#'
#' @param chat_obj A chat object created from `create_chat()`
#' @param ... A named list of parameters to add to the chat object. Must be valid parameters from the API documentation.
#'
#' @return A chat object with the parameters added
#'
#' @examples
#' \dontrun{dotenv::load_dot_env()
#' chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))|>
#'   add_model('gpt-3.5-turbo') |>
#'   add_params('temperature' = 0.5, 'max_tokens' = 100)
#'
#' chat_mistral <- create_chat('mistral', Sys.getenv('MISTRAL_DEV_KEY')) |>
#'   add_model('mistral-large-latest') |>
#'   add_params('temperature' = 0.5, 'max_tokens' = 100)
#' }
#' @export
#' @name add_params
add_params <- function(chat, ...) UseMethod("add_params")

#' @describeIn add_params Add parameters to a `tidychat` object.
#' @export
add_params.tidychat <- function(chat, ...) {
  params <- modifyList(get_params(chat), list(...))
  attr(chat, "params") <- params
  chat
}

#' Get parameters from a chat object.
#' @param chat An object of class `tidychat`.
#' @export
#' @name get_params
get_params <- function(chat) UseMethod("get_params")

#' @describeIn get_params Add parameters to a `tidychat` object.
#' @export
get_params.tidychat <- function(chat) {
  attr(chat, "params")
}
