% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/create_chat.R
\name{create_chat}
\alias{create_chat}
\title{Create a chat object.}
\usage{
create_chat(
  vendor,
  api_key = "",
  port = if (vendor == "ollama") 11434 else NULL,
  api_version = ""
)
}
\arguments{
\item{vendor}{A character vector with one element. Currently, only 'openai', 'mistral', 'anthropic' and 'ollama' are supported.}

\item{api_key}{The API key for the vendor's chat engine. If the vendor is 'ollama', this parameter is not required.}

\item{port}{The port number for the ollama chat engine. Default to ollama's standard port. If the vendor is not 'ollama', this parameter is not required.}

\item{api_version}{Api version that is required for Anthropic}
}
\value{
A chat object
}
\description{
Create a chat object.
}
\examples{
\dontrun{
dotenv::load_dot_env()
chat_openai <- create_chat('openai', Sys.getenv('OAI_DEV_KEY'))
chat_mistral <- create_chat('mistral', Sys.getenv('MISTRAL_DEV_KEY'))
}
}
