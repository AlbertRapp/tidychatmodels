#' Prints all messages to the console and saves them invisibly
#'
#' @param chat_obj A chat object created from `create_chat()`
#' @param silent A logical vector with one element. If TRUE, the messages are not printed to the console.
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
#'   msgs_openai <- chat_openai |> extract_chat()
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
#'   msgs_mistral <- chat_mistral |> extract_chat()
#'   }
extract_chat <- function(chat_obj, silent = FALSE) {
  if (!silent) {
    cli::cli_div(
      theme = list(
        span.system_msg = list(color = "magenta"),
        span.assistant_msg = list(color = "blue"),
        span.user_msg = list(color = "green")
      )
    )

    for (i in seq_along(chat_obj$messages)) {
      if (chat_obj$messages[[i]]$role == "system") {
        cli::cli_text("{.system_msg System: {chat_obj$messages[[i]]$content}}")
      }

      if (chat_obj$messages[[i]]$role == "user") {
        cli::cli_text("{.user_msg User: {chat_obj$messages[[i]]$content}}")
      }

      if (chat_obj$messages[[i]]$role == "assistant") {
        cli::cli_text("{.assistant_msg Assistant: {chat_obj$messages[[i]]$content}}")
      }
    }
  }
  transposed_and_flattened_chats <- chat_obj$messages |>
    purrr::transpose() |>
    purrr::map(unlist)

  msg_tibble <- tibble::tibble(
    role = transposed_and_flattened_chats$role,
    message = transposed_and_flattened_chats$content
  )
  if (!silent) {
    return(invisible(msg_tibble))
  } else {
    return(msg_tibble)
  }
}
