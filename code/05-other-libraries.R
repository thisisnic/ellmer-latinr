# 5 - Bonus: Other Libraries for Working with LLMs in R
# Using LLMs in R with ellmer - LatinR 2026
#
# Bonus content - we'll cover this if there's time at the end.

# install.packages(c("shiny", "bslib", "shinychat", "querychat", "vitals"))

library(ellmer)

## shinychat - chat UIs in Shiny
## https://posit-dev.github.io/shinychat/

# A minimal chatbot: a chat_ui() in the UI, and in the server we stream the
# model's reply into it every time the user sends a message

library(shiny)
library(bslib)
library(shinychat)

ui <- page_fillable(
  chat_ui("chat")
)

server <- function(input, output, session) {
  chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)

## The dog adoption assistant from section 4, as an app

# Same ellmer chat object as before - a system prompt, the dog listings, and
# the save_shortlist tool. shinychat just gives it a user interface.

dogs_csv <- paste(readLines("data/dogs_details.csv"), collapse = "\n")

prompt <- paste(
  "You are a dog adoption assistant helping the user choose a dog",
  "from the listings below. Keep answers short.\n\nDogs available:\n",
  dogs_csv
)

save_shortlist <- function(names) {
  path <- "dog_shortlist.txt"
  if (file.exists(path)) {
    stop("File already exists, please choose a different path")
  }
  writeLines(names, path)
  paste("Saved", length(names), "dogs to", path)
}

save_shortlist_tool <- tool(
  save_shortlist,
  "Save a shortlist of dog names to a text file",
  arguments = list(
    names = type_array(type_string("Dog names"))
  )
)

# Welcome message with clickable suggestions
welcome <- "
**Hi! I can help you pick a dog to adopt.** 🐶

Try one of these:

* <span class=\"suggestion submit\">Which dogs would suit a small flat?</span>
* <span class=\"suggestion submit\">Which dogs are good with other dogs?</span>
* <span class=\"suggestion\">Save a shortlist of ...</span>
"

ui <- page_fillable(
  chat_ui("chat", greeting = welcome)
)

server <- function(input, output, session) {
  chat <- chat_openrouter(
    model = "anthropic/claude-haiku-5.5",
    system_prompt = prompt
  )
  chat$register_tool(save_shortlist_tool)

  observeEvent(input$chat_user_input, {
    stream <- chat$stream_async(input$chat_user_input)
    chat_append("chat", stream)
  })
}

shinyApp(ui, server)

## querychat - ask questions of a data frame in plain language
## https://posit-dev.github.io/querychat/

# querychat turns questions into SQL, runs the SQL on your data with DuckDB,
# and shows you the query. Only the schema (column names, types, categories)
# is sent to the model - the rows themselves never leave your machine.

library(querychat)

dogs <- readr::read_csv("data/dogs_details.csv")

querychat_app(
  dogs,
  client = chat_openrouter(model = "anthropic/claude-haiku-5.5")
)

# Try asking:
#   "Show me dogs that are good with other dogs"
#   "What's the average adoption fee by age?"
#   "Which city has the most dogs listed?"

## Giving querychat more context

# Describing the data helps the model write better SQL. We can also drop the
# long free-text column so the schema is smaller. (querychat names the SQL
# table after the variable, so assign first rather than passing an expression.)

dogs_short <- dplyr::select(dogs, -description)

querychat_app(
  dogs_short,
  client = chat_openrouter(model = "anthropic/claude-haiku-5.5"),
  greeting = "Ask me anything about the dogs available for adoption!",
  data_description = "
    Dogs listed for adoption in the USA.
    age is one of Baby, Young, Adult or Senior.
    adoption_fee is in US dollars.
    other_dogs is TRUE if the dog can live with other dogs.
  "
)

## vitals - evaluating LLM output
## https://vitals.tidyverse.org/

# TODO: placeholder - quick demo of vitals
