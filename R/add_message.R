#' Add messages to a chat object.
#'
#' @param chat A chat object of class `tidychat`.
#' @param message A character vector with one element. The message to add to the chat.
#' @param role A character vector with one element. The role of the message. Typically 'user' or 'system'.
#'
#' @return A chat object with the messages added
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
#' @export
#' @name add_message
add_message <- function(chat, message, role = "user") UseMethod("add_message")

#' @describeIn add_message Add a message to a `tidychat` object.
#' @export
add_message.tidychat <- function(chat, message, role = "user") {
  messages <- get_messages(chat)

  messages[[length(messages) + 1]] <- list(
    role = role,
    content = message
  )

  attr(chat, "messages") <- messages
  chat
}

#' Get messages from a chat object.
#' @param chat An object of class `tidychat`.
#' @export
#' @name get_messages
get_messages <- function(chat) UseMethod("get_messages")

#' @describeIn get_messages Get messages from a `tidychat` object.
#' @export
get_messages.tidychat <- function(chat) {
  attr(chat, "messages")
}

#' Append a message to a `tidychat` object.
#' @param chat An object of class `tidychat`.
#' @param response The response as returned by `perform_query`.
#' @param ... Ignored for future compatibility.
#' @export
#' @name append_message
append_message <- function(chat, response, ...) UseMethod("append_message")

#' @describeIn append_message Appends a message to a `tidychat` object.
#' @export
append_message.tidychat <- function(chat, response, ...) {
  messages <- get_messages(chat)

  messages[[length(messages) + 1]] <- response$choices[[1]]$message

  attr(chat, "messages") <- messages
  invisible(chat)
}

#' @describeIn append_message Appends a message to a `ollama` object.
#' @export
append_message.ollama <- function(chat, response, ...){
  messages <- get_messages(chat)
  messages[[length(messages) + 1]] <- response$message
  attr(chat, "messages") <- messages
  invisible(chat)
}

#' @describeIn append_message Appends a message to a `anthropic` object.
#' @export
append_message.antropic <- function(chat, response, ...){
  messages <- get_messages(chat)
  messages[[length(messages) + 1]] <- list(
    role = "assistant",
    content = response$content[[1]]$text
  )
  attr(chat, "messages") <- messages
  invisible(chat)
}
