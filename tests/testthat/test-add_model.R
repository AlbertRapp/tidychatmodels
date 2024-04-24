test_that("model can be added to chat", {
  #ollama
  chat <- new_chat_ollama(port = 14252) |>
    add_model("COOL-MODEL-NAME")
  expect_equal(get_model(chat), "COOL-MODEL-NAME")

  #openai
  chat <- new_chat_openai(key = "secret") |>
    add_model("COOL-MODEL-NAME")
  expect_equal(get_model(chat), "COOL-MODEL-NAME")

  #mistral
  chat <- new_chat_mistral(key = "secret") |>
    add_model("COOL-MODEL-NAME")
  expect_equal(get_model(chat), "COOL-MODEL-NAME")
})
