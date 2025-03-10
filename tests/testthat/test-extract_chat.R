test_that("chats can be extracted", {
  chat <- new_chat_ollama(port = 3000) |>
    add_message(
      role = "system",
      message = "You are a chatbot that completes texts.
    You do not return the full text.
    Just what you think completes the text."
    ) |>
    add_message(
      # default role = "user"
      "2 + 2 is 4, minus 1 that\"s 3, "
    ) |>
    add_message(
      role = "assistant",
      "This is a fake reply"
    )

  msgs <- chat |> extract_chat(silent = TRUE)

  expect_equal(
    msgs,
    tibble::tibble(
      role = c("system", "user", "assistant"),
      message = c(
        "You are a chatbot that completes texts.\n    You do not return the full text.\n    Just what you think completes the text.",
        "2 + 2 is 4, minus 1 that\"s 3, ",
        "This is a fake reply"
      )
    )
  )
})
