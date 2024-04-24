test_that("parameters can be added to chat", {
  #ollama
  chat <- new_chat_ollama(port = 14252) |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(
    get_params(chat),
    list(stream = FALSE, parameterA = 2343, parameterB = 23421)
    # stream = FALSE is default for this vendor
    # this also checks that multile `add_params` calls are merged
  )

  #openai
  chat <- new_chat_openai(key = "secret")  |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(get_params(chat), list(parameterA = 2343, parameterB = 23421))

  #mistral
  chat <- new_chat_mistral(key = "secret")  |>
    add_params(parameterA = 2343, parameterB = 23421)
  expect_equal(get_params(chat), list(parameterA = 2343, parameterB = 23421))
})
