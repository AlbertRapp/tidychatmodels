test_that("user messages can be added to chat", {
  #ollama
  chat <- create_chat('ollama', port = 14252) |>
    add_message('This is a message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'user', content = 'This is a message'),
      list(role = 'user', content = 'And this is another one')
    )
  )

  #openai
  chat <- create_chat('openai', api_key = 'secret') |>
    add_message('This is a message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'user', content = 'This is a message'),
      list(role = 'user', content = 'And this is another one')
    )
  )

  #mistral
  chat <- create_chat('mistral', api_key = 'secret') |>
    add_message('This is a message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'user', content = 'This is a message'),
      list(role = 'user', content = 'And this is another one')
    )
  )
})


test_that("system messages can be added to chat", {
  #ollama
  chat <- create_chat('ollama', port = 14252) |>
    add_message(role = 'system', 'This is a SYSTEM message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'system', content = 'This is a SYSTEM message'),
      list(role = 'user', content = 'And this is another one')
    )
  )

  #openai
  chat <- create_chat('openai', api_key = 'secret') |>
    add_message(role = 'system', 'This is a SYSTEM message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'system', content = 'This is a SYSTEM message'),
      list(role = 'user', content = 'And this is another one')
    )
  )

  #mistral
  chat <- create_chat('mistral', api_key = 'secret') |>
    add_message(role = 'system', 'This is a SYSTEM message') |>
    add_message('And this is another one')
  expect_equal(
    chat$messages,
    list(
      list(role = 'system', content = 'This is a SYSTEM message'),
      list(role = 'user', content = 'And this is another one')
    )
  )
})
