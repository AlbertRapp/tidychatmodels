#' Add a model to a chat object.
#'
#' @param chat An object of class `tidychat`.
#' @param model A character vector with one element. 
#'   The model to use for the chat. 
#'   You can use any chat completion model from openAI and mistral.ai here. 
#'   Refer to their API docs for specific names.
#'
#' @return A chat object with the model added
#'
#' @examples
#' \dontrun{
#' dotenv::load_dot_env()
#' chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))|>
#'   add_model('gpt-3.5-turbo')
#'
#' chat_mistral <- create_chat('mistral', Sys.getenv('MISTRAL_DEV_KEY')) |>
#'   add_model('mistral-large-latest')
#' }
#' @export
#' @name add_model
add_model <- function(chat, model) {
  attr(chat, "model") <- model
  chat
}

#' Get model from a chat object.
#' @param chat An object of class `tidychat`.
#' @export
#' @name get_model
get_model <- function(chat) UseMethod("get_model")

#' @describeIn get_model Gets a model from a `tidychat` object.
#' @export
get_model.tidychat <- function(chat) {
  attr(chat, "model")
}
