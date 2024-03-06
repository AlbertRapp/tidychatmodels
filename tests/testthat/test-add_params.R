test_that("parameters can be added to chat", {
  #ollama
  chat <- create_chat('ollama', port = 14252) |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(
    chat$params,
    list(stream = FALSE, parameterA = 2343, parameterB = 23421)
    # stream = FALSE is default for this vendor
    # this also checks that multile `add_params` calls are merged
  )

  #openai
  chat <- create_chat('openai', api_key = 'secret')  |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(chat$params, list(parameterA = 2343, parameterB = 23421))

  #mistral
  chat <- create_chat('mistral', api_key = 'secret')  |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(chat$params, list(parameterA = 2343, parameterB = 23421))
})
