test_that("ollama chat can be created", {
  chat <- new_chat_ollama(port = 14252)

  expect_equal(
    chat$url,
    "http://localhost:14252/api/chat"
  )

  expect_equal(get_params(chat)$stream, FALSE)
  expect_equal(get_messages(chat), list())
  expect_equal(chat$headers, list())
})


test_that("openai chat can be created", {
  chat <- new_chat_openai(key = "secret")

  expect_equal(
    chat$url,
    "https://api.openai.com/v1/chat/completions"
  )

  expect_equal(get_params(chat)$stream, NULL)
  expect_equal(get_messages(chat), list())
  headers_list <- list(
    "Authorization" = "Bearer secret",
    "Content-Type" = "application/json"
  )
  attributes(headers_list) <- list(
    names = c("Authorization", "Content-Type"),
    "redact" = character()
  )
  expect_equal(
    chat$headers,
    headers_list
  )
})

test_that("mistral chat can be created", {
  chat <- new_chat_mistral(key = "secret")

  expect_equal(
    chat$url,
    "https://api.mistral.ai/v1/chat/completions"
  )

  expect_equal(get_params(chat)$stream, NULL)
  expect_equal(get_messages(chat), list())
  headers_list <- list("Bearer secret", "application/json", "application/json")
  attributes(headers_list) <- list(
    names = c("Authorization", "Content-Type", "Accept"),
    "redact" = character()
  )
  expect_equal(
    chat$headers,
    headers_list
  )
})


test_that("anthropic chat can be created", {
  chat <- new_chat_anthropic(key = "secret", version = "2023-06-01")

  expect_equal(
    chat$url,
    "https://api.anthropic.com/v1/messages"
  )

  expect_equal(get_params(chat)$stream, NULL)
  expect_equal(get_messages(chat), list())
  headers_list <- list("secret", "application/json", "2023-06-01")
  attributes(headers_list) <- list(
    names = c("x-api-key", "Content-Type", "anthropic-version"),
    "redact" = character()
  )
  expect_equal(
    chat$headers,
    headers_list
  )
})
