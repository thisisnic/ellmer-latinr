# 1 - Getting Started with LLMs in R
# Using LLMs in R with ellmer - LatinR 2026

## Editing your .Renviron

# Add a line like OPENROUTER_API_KEY=sk12345567890, save, then restart R
usethis::edit_r_environ()

## Starting a conversation

library(ellmer)
chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")

## Sending a message to the LLM

chat$chat("What is the most popular dog breed in the world?
  Answer succinctly.")

## Your turn (1)

# 1. Save your API key with usethis::edit_r_environ() and restart R
# 2. Start a conversation: chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
# 3. Ask it a question with chat$chat() and check you get an answer back

## What's in the chat object?

# Provider and model, number of turns, input and output tokens,
# and the user / assistant turns themselves
chat

## Counting tokens

# Totals for every call in this R session, across all chats
token_usage()

## Continuing the conversation

chat$chat("How long does this breed of dog usually live?")

# Input tokens went up: the whole conversation is sent every time
chat

## Reset - just start a new chat

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat("What is its favourite food?")
# A new chat object has no history - the Labrador is gone

## Chatting interactively

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
# Opens the chat in a browser window. Close it and chat still has all the turns
live_browser(chat)

chat

## Your turn (2)

# 1. Start a new chat and open it with live_browser(chat)
# 2. Ask a few questions, including a follow-up that relies on an earlier answer
# 3. Close the browser window, then print chat - what do you see?

## Today's data: dog adoption listings

library(readr)
dogs <- read_csv("data/dogs.csv")
View(dogs)

## Giving the model something to work with

# chat$chat() takes any number of pieces of content and sends them together
boris <- dogs$description[1]

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat("Give me a quick summary of this dog", boris)

## Your turn (3)

# 1. Pick a different dog from dogs and pass its description to chat$chat()
# 2. Ask: would this dog suit a flat with no garden?
# 3. Ask a follow-up question without repeating the description
