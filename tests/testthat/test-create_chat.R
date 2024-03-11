test_that("ollama chat can be created", {
  chat <- create_chat('ollama', port = 14252)

  expect_equal(
    chat$engine$url,
    'http://localhost:14252/api/chat'
  )

  expect_equal(chat$params$stream,FALSE)
  expect_equal(chat$messages, list())
  expect_equal(chat$engine$headers, list())
})


test_that("openai chat can be created", {
  chat <- create_chat('openai', api_key = 'secret')

  expect_equal(
    chat$engine$url,
    'https://api.openai.com/v1/chat/completions'
  )

  expect_equal(chat$params$stream, NULL)
  expect_equal(chat$messages, list())
  headers_list <- list(
    'Authorization' = 'Bearer secret',
    'Content-Type' = 'application/json'
  )
  attributes(headers_list) <- list(
    names = c('Authorization', 'Content-Type'),
    'redact' = character()
  )
  expect_equal(
    chat$engine$headers,
    headers_list
  )
})

test_that("mistral chat can be created", {
  chat <- create_chat('mistral', api_key = 'secret')

  expect_equal(
    chat$engine$url,
    'https://api.mistral.ai/v1/chat/completions'
  )

  expect_equal(chat$params$stream, NULL)
  expect_equal(chat$messages, list())
  headers_list <- list('Bearer secret','application/json', 'application/json')
  attributes(headers_list) <- list(
    names = c('Authorization', 'Content-Type', 'Accept'),
    'redact' = character()
  )
  expect_equal(
    chat$engine$headers,
    headers_list
  )
})


test_that("anthropic chat can be created", {
  chat <- create_chat('anthropic', api_key = 'secret', api_version = '2023-06-01')

  expect_equal(
    chat$engine$url,
    'https://api.anthropic.com/v1/messages'
  )

  expect_equal(chat$params$stream, NULL)
  expect_equal(chat$messages, list())
  headers_list <- list('secret','application/json', '2023-06-01')
  attributes(headers_list) <- list(
    names = c('x-api-key', 'Content-Type', 'anthropic-version'),
    'redact' = character()
  )
  expect_equal(
    chat$engine$headers,
    headers_list
  )
})


