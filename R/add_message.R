#' Add messages to a chat object.
#'
#' @param chat_obj A chat object created from `create_chat()`
#' @param message A character vector with one element. The message to add to the chat.
#' @param role A character vector with one element. The role of the message. Typically 'user' or 'system'.
#'
#' @return A chat object with the messages added
#' @export
#'
#' @examples
#' \dontrun{dotenv::load_dot_env()
#' chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))|>
#'   add_model('gpt-3.5-turbo') |>
#'   add_params('temperature' = 0.5, 'max_tokens' = 100) |>
#'   add_message(
#'     role = 'system',
#'     message = 'You are a chatbot that completes texts.
#'     You do not return the full text.
#'     Just what you think completes the text.'
#'   ) |>
#'   add_message('2 + 2 is 4, minus 1 that\'s 3, ')
#'
#' chat_mistral <- create_chat('mistral', Sys.getenv('MISTRAL_DEV_KEY')) |>
#'   add_model('mistral-large-latest') |>
#'   add_params('temperature' = 0.5, 'max_tokens' = 100) |>
#'   add_message(
#'     role = 'system',
#'     message = 'You are a chatbot that completes texts.
#'     You do not return the full text.
#'     Just what you think completes the text.'
#'   ) |>
#'   add_message('2 + 2 is 4, minus 1 that\'s 3, ')
#'  }
add_message <- function(chat_obj, message, role = 'user') {

  chat_obj$messages[[length(chat_obj$messages) + 1]] <- list(
    role = role,
    content = message
  )
  chat_obj
}


