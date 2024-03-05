#' Add a model to a chat object.
#'
#' @param chat_obj A chat object created from `create_chat()`
#' @param ... A named list of parameters to add to the chat object. Must be valid parameters from the API documentation.
#'
#' @return A chat object with the parameters added
#' @export
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
add_params <- function(chat_obj, ...) {
  if (is.null(chat_obj$params)) {
    chat_obj$params <- utils::modifyList(list(), list(...))
  } else {
    chat_obj$params <- utils::modifyList(chat_obj$params, list(...))
  }
  chat_obj
}





