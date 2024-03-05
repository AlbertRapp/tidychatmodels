#' Sends the chat to the engine and adds the response to the chat object
#'
#' @param chat_obj A chat object created from `create_chat()`
#'
#' @return A chat object with the responses added
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
#'   chat_openai <- chat_openai |>
#'     perform_chat()
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
#'   chat_mistral <- chat_mistral |>
#'     perform_chat()
#'  }
perform_chat <- function(chat_obj) {
  prepared_engine <- chat_obj$engine |>
    httr2::req_body_json(
      data = rlang::list2(
        messages = chat_obj$messages,
        model = chat_obj$model,
        !!!chat_obj$params
      )
    )

  response <- prepared_engine |>
    httr2::req_perform() |>
    httr2::resp_body_json()

  chat_obj$messages[[length(chat_obj$messages) + 1]] <- response$choices[[1]]$message
  chat_obj$usage[[length(chat_obj$usage) + 1]] <- response$usage
  chat_obj
}

