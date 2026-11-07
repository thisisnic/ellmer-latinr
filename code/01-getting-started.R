# 1 - Getting Started with LLMs in R
# Using LLMs in R with ellmer - LatinR 2026

## Editing your .Renviron

usethis::edit_r_environ()

## Starting a conversation

library(ellmer)
chat <- chat_openrouter(model = "openai/gpt-6.1-terra")

## Sending a message to the LLM

library(ellmer)
chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat("What is the most popular dog breed in the world?
  Answer succinctly.")

## Turns

chat

## Continuing the conversation

chat$chat("What are they like to live with?")
chat$chat("How long do they usually live?")
chat

## Reset - just start a new chat

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat("What were we saying earlier?")

## Training cutoff date

chat$chat("what date is it right now?")
chat$chat("Are you sure about that?")

## Your turn

# 1. Set up your API key using usethis::edit_r_environ() + restart R
# 2. Start a conversation: chat_openrouter(model = "openai/gpt-6.1-terra")
# 3. Paste one dog's description from dogs.csv and ask: would this dog suit
#    a flat with no garden?
# 4. Ask a follow-up question without repeating the description
