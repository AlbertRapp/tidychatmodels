test_that("model can be added to chat", {
  #ollama
  chat <- create_chat('ollama', port = 14252) |>
    add_model('COOL-MODEL-NAME')
  expect_equal(chat$model,'COOL-MODEL-NAME')

  #openai
  chat <- create_chat('openai', api_key = 'secret') |>
    add_model('COOL-MODEL-NAME')
  expect_equal(chat$model,'COOL-MODEL-NAME')

  #mistral
  chat <- create_chat('mistral', api_key = 'secret') |>
    add_model('COOL-MODEL-NAME')
  expect_equal(chat$model,'COOL-MODEL-NAME')
})
