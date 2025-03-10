test_that("Mistral request fulfills API structure", {
  chat <- new_chat_mistral(key = "secret") |>
    add_model("mistral-large-latest") |>
    add_params(temperature = 0.5, max_tokens = 100) |>
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
    perform_chat(dry_run = TRUE)

  expect_equal(
    chat$body$data$messages,
    list(
      list(role = "system", content = "You are a chatbot that completes texts.\n    You do not return the full text.\n    Just what you think completes the text."),
      list(role = "user", content = "2 + 2 is 4, minus 1 that\"s 3, ")
    )
  )
  expect_equal(chat$url, "https://api.mistral.ai/v1/chat/completions")
  expect_equal(chat$body$data$model, "mistral-large-latest")
  expect_equal(chat$body$data$temperature, 0.5)
  expect_equal(chat$body$data$max_tokens, 100)
  expect_equal(chat$headers$`Content-Type`, "application/json")
  expect_equal(chat$headers$Authorization, "Bearer secret")
  expect_equal(chat$headers$Accept, "application/json")

})


test_that("openAI request fulfills API structure", {
  chat <- new_chat_openai(key = "secret") |>
    add_model("gpt-3.5-turbo") |>
    add_params(temperature = 0.5, max_tokens = 100) |>
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
    perform_chat(dry_run = TRUE)

  expect_equal(
    chat$body$data$messages,
    list(
      list(role = "system", content = "You are a chatbot that completes texts.\n    You do not return the full text.\n    Just what you think completes the text."),
      list(role = "user", content = "2 + 2 is 4, minus 1 that\"s 3, ")
    )
  )
  expect_equal(chat$url, "https://api.openai.com/v1/chat/completions")
  expect_equal(chat$body$data$model, "gpt-3.5-turbo")
  expect_equal(chat$body$data$temperature, 0.5)
  expect_equal(chat$body$data$max_tokens, 100)
  expect_equal(chat$headers$`Content-Type`, "application/json")
  expect_equal(chat$headers$Authorization, "Bearer secret")

})

test_that("ollama request fulfills API structure", {
  chat <- new_chat_ollama(port = 25223) |>
    add_model("gemma:7b") |>
    add_message("What is love? IN 10 WORDS.") |>
    perform_chat(dry_run = TRUE)

  expect_equal(
    chat$body$data$messages,
    list(
      list(role = "user", content = "What is love? IN 10 WORDS.")
    )
  )
  expect_equal(chat$url, "http://localhost:25223/api/chat")
  expect_equal(chat$body$data$model, "gemma:7b")
  expect_equal(chat$body$data$stream, FALSE)
  expect_equal(chat$headers, list())

})



test_that("Anthropic request fulfills API structure (when system msg present)", {
  chat <- new_chat_anthropic(key = "secret", version = "2023-06-01") |>
    add_model("claude-3-opus-20240229") |>
    add_params(temperature = 0.5, max_tokens = 100) |>
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
    perform_chat(dry_run = TRUE)

  expect_equal(
    chat$body$data$messages,
    list(
      list(role = "user", content = "2 + 2 is 4, minus 1 that\"s 3, ")
    )
  )
  expect_equal(
    chat$body$data$system,
    "You are a chatbot that completes texts.\n    You do not return the full text.\n    Just what you think completes the text."
  )
  expect_equal(chat$url, "https://api.anthropic.com/v1/messages")
  expect_equal(chat$body$data$model, "claude-3-opus-20240229")
  expect_equal(chat$body$data$temperature, 0.5)
  expect_equal(chat$body$data$max_tokens, 100)
  expect_equal(chat$headers$`Content-Type`, "application/json")
  expect_equal(chat$headers$`x-api-key`, "secret")
  expect_equal(chat$headers$`anthropic-version`, "2023-06-01")

})


test_that("Anthropic request fulfills API structure (without system msg)", {
  chat <- new_chat_anthropic(key = "secret", version = "2023-06-01") |>
    add_model("claude-3-opus-20240229") |>
    add_params(temperature = 0.5, max_tokens = 100) |>
    add_message(
      # default role = "user"
      "2 + 2 is 4, minus 1 that\"s 3, "
    ) |>
    perform_chat(dry_run = TRUE)

  expect_equal(
    chat$body$data$messages,
    list(
      list(role = "user", content = "2 + 2 is 4, minus 1 that\"s 3, ")
    )
  )
  expect_equal(chat$body$data$system, NULL)
  expect_equal(chat$url, "https://api.anthropic.com/v1/messages")
  expect_equal(chat$body$data$model, "claude-3-opus-20240229")
  expect_equal(chat$body$data$temperature, 0.5)
  expect_equal(chat$body$data$max_tokens, 100)
  expect_equal(chat$headers$`Content-Type`, "application/json")
  expect_equal(chat$headers$`x-api-key`, "secret")
  expect_equal(chat$headers$`anthropic-version`, "2023-06-01")
})
