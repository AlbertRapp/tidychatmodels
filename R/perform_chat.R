#' Sends the chat to the engine and adds the response to the chat object
#'
#' @param chat An object of class `tidychat`.
#' @param dry_run A logical indicating whether to return the prepared_engine
#'   `httr2` request without actually sending out the request to the vendor. Defaults to FALSE.
#' @param ... Ignored for future compatibility.
#'
#' @return A chat object with the responses added
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
#' 
#' @export
#' @name perform_chat
perform_chat <- function(chat, dry_run = FALSE, ...) UseMethod("perform_chat")

#' @describeIn perform_chat Perform a chat on a `tidychat` object.
#' @export
perform_chat.tidychat <- function(chat, dry_run = FALSE, ...){
  # prepare the query
  prepared <- prepare_engine(chat)

  # return early if dry run
  if (dry_run) return(prepared)

  # perform the query
  response <- perform_query(chat, prepared)

  # increment the uses by 1
  chat <- inc_uses(chat)

  # post process the query
  chat <- append_message(chat, response)

  invisible(chat)
}

#' Prepare tidychat engine query
#' @param chat An object of class `tidychat`.
#' @param ... Ignored for future compatibility.
#' @export
#' @name prepare_engine
prepare_engine <- function(chat, ...) UseMethod("prepare_engine")

#' @describeIn prepare_engine Prepare a tidychat engine query.
#' @export
prepare_engine.tidychat <- function(chat, ...) {
  chat |>
    httr2::req_body_json(
      data = rlang::list2(
        messages = get_messages(chat),
        model = get_model(chat),
        !!!get_params(chat)
      )
    )
}

#' @describeIn prepare_engine Prepare an anthropic engine query.
#' @export
prepare_engine.anthropic <- function(chat, ...){
  msgs <- get_messages(chat)

  non_system_msgs <- msgs[purrr::map_lgl(msgs, \(x) x$role != "system")]
  system_msg <- msgs[purrr::map_lgl(msgs, \(x) x$role == "system")]

  if (length(system_msg) > 1) stop("There can only be one system message")

  if (length(system_msg) == 0) {
    prepared_engine <- get_engine(chat) |>
      httr2::req_body_json(
        data = rlang::list2(
          messages = non_system_msgs,
          model = get_model(chat),
          !!!get_params(chat)
        )
      )
    return(prepared_engine)
  }

  get_engine(chat) |>
    httr2::req_body_json(
      data = rlang::list2(
        messages = non_system_msgs,
        model = get_model(chat),
        system = system_msg[[1]]$content,
        !!!get_params(chat)
      )
    )
}

#' Perform a tidychat engine query
#' @param chat An object of class `tidychat`.
#' @param prepared_query A prepared query as returned by `prepare_engine`.
#' @param ... Ignored for future compatibility.
#' @export
#' @name perform_query
perform_query <- function(chat, prepared_query, ...) UseMethod("perform_query")

#' @describeIn perform_query Perform a tidychat engine query.
#' @export
perform_query.tidychat <- function(chat, prepared_query, ...){
  prepared_query |>
    httr2::req_perform() |>
    httr2::resp_body_json()
}
