# 2 - Prompt Engineering
# Using LLMs in R with ellmer - LatinR 2026

library(ellmer)
library(dplyr)

dogs <- readr::read_csv("data/dogs.csv")
dog_description <- dogs$description[1]

dog_description

## Without guidance the model decides what matters

# Something a bit more involved, so we switch to Sonnet - more capable than
# Haiku, about 20x the price per token (still fractions of a cent per call)
chat <- chat_openrouter(model = "anthropic/claude-sonnet-5.5")
chat$chat("Summarise this dog:", dog_description)

## A system prompt sets the ground rules for the whole conversation

prompt <- "Give me a few bullet points to describe this dog's name,
what it's like, age, and preferences"

chat <- chat_openrouter(
  model = "anthropic/claude-sonnet-5.5",
  system_prompt = prompt
)
chat$chat("Summarise this dog:", dog_description)
chat$chat("Summarise this dog:", dogs$description[2])
chat$chat("Summarise this dog:", dogs$description[3])

# Within a conversation the format stays consistent - the earlier answers
# are in the context. But start a new conversation...

chat <- chat_openrouter(
  model = "anthropic/claude-sonnet-5.5",
  system_prompt = prompt
)
chat$chat("Summarise this dog:", dogs$description[3])

# ...and it's a little different each time. LLMs are non-deterministic.

## A more specific system prompt for more consistent results

prompt <- "You are a dog adoption assistant helping people find dogs to adopt.
Summarise the dog description you are given to help potential adopters decide
if the dog is a good fit for them. Respond in 50 words or fewer.

## Output format

Name: the dog's name
Summary: a 1 sentence description
Age group: one of Baby, Young, Adult, Senior
Likes and dislikes: what the dog does and doesn't enjoy"

chat <- chat_openrouter(
  model = "anthropic/claude-sonnet-5.5",
  system_prompt = prompt
)
chat$chat("Summarise this dog:", dogs$description[1])
chat$chat("Summarise this dog:", dogs$description[2])
chat$chat("Summarise this dog:", dogs$description[3])

# A role, a clear task, and an output format are usually enough. But the
# result is still free text we'd have to parse. In the next section we make
# the model return data instead.

## Your turn

# 1. Pick a different dog from the dataset and run the prompt on it
# 2. Add one more field to the output format that YOU would want to know
#    before adopting a dog
