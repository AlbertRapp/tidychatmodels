#' Add a model to a chat object.
#'
#' @param chat_obj A chat object created from `create_chat()`
#' @param model A character vector with one element. The model to use for the chat. You can use any chat completion model from openAI and mistral.ai here. Refer to their API docs for specific names.
#'
#' @return A chat object with the model added
#' @export
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
add_model <- function(chat_obj, model) {
  chat_obj$model <- model
  chat_obj
}

