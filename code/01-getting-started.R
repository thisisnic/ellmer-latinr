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
chat$chat("What is the most popular LGBT movie of all time?
  Answer succinctly.")

## Turns

chat

## Continuing the conversation

chat$chat("Who were the stars of that movie?")
chat$chat("What year was it released?")
chat

## Reset - just start a new chat

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat("What were we saying earlier?")

## Training cutoff date

chat$chat("what date is it right now?")
chat$chat("Are you sure about that?")

## Giving the model web search - add ":online" to the model name

chat <- chat_openrouter(model = "openai/gpt-6.1-terra:online")
chat$chat("what date is it right now?")
chat$chat("What LGBT movies are being released this month?")

## Your turn

# 1. Set up your API key using usethis::edit_r_environ() + restart R
# 2. Start a conversation: chat_openrouter(model = "openai/gpt-6.1-terra")
# 3. Ask what the most popular LGBT movie was in 1995 and then 2026
