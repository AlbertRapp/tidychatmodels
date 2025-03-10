#' Get params from a chat object
#' @param chat An object of class `tidychat`.
#' @export
get_params <- function(chat) UseMethod("get_params")

#' @export
get_params.tidychat <- function(chat) {
  attr(chat, "params")
}

#' Get uses from a chat object
#' @param chat An object of class `tidychat`.
#' @export
get_uses <- function(chat) UseMethod("get_uses")

#' @export
get_uses.tidychat <- function(chat) {
  attr(chat, "uses")
}

#' Set uses from a chat object
#' @param chat An object of class `tidychat`.
#' @param value An integer to set the uses to.
#' @export
set_uses <- function(chat, value) UseMethod("set_uses")

#' @export
set_uses.tidychat <- function(chat, value) {
  attr(chat, "uses") <- value
} 

#' Increment uses from a chat object by 1
#' @param chat An object of class `tidychat`.
#' @export
inc_uses <- function(chat) UseMethod("inc_uses")

#' @export
inc_uses.tidychat <- function(chat) {
  uses <- attr(chat, "uses")
  attr(chat, "uses") <- uses + 1
  return(chat)
} 

#' Get engine from a `tidychat` object
#' @param chat An object of class `tidychat`.
#' @export
get_engine <- function(chat) UseMethod("get_engine")

#' @export
get_engine.tidychat <- function(chat) {
  attr(chat, "engine")
}
