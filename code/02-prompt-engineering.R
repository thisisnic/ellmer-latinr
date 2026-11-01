# 2 - Prompt Engineering
# Using LLMs in R with ellmer - LatinR 2026

## Load the data to work with

library(tidyverse)
movies <- read_csv("data/movies.csv")

pride_synopsis <- movies |>
  filter(title == "Pride") |>
  pull(synopsis)

pride_synopsis

## Ask questions

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat("What year was this movie set in?", pride_synopsis)

## The LLM is very chatty!

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat("Summarise this movie:", pride_synopsis)

## Setting the system prompt

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = "Respond in 35 words or fewer"
)
chat$chat("Summarise this movie:", pride_synopsis)
chat$chat("tell me every character and what they do")

## Run it again though...responses vary

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = "Respond in 35 words or fewer"
)
chat$chat("Summarise this movie:", pride_synopsis)

## 1. Define a role - prompt

prompt <- "You are a movie summariser whose job is to sum up the
genre and themes of movies to help users decide if they want to watch.
Respond in 50 words or fewer"

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)
chat$chat("Summarise the movie: ", pride_synopsis)

# if we run it again we get different output
chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)
chat$chat("Summarise the movie: ", pride_synopsis)

##  2 - Defining the output format - prompt

prompt <- "You are a movie summariser whose job is to sum up the
genre and themes of movies to help users decide if they want to watch.
Respond in 50 words or fewer

## Output format

Plot outline: a 1 sentence description

Genre: movie genre

Setting: time and place
"

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)

chat$chat("Summarise the movie: ", pride_synopsis)

## 3 - Getting more specific - prompt

prompt <- "You are a movie summariser whose job is to sum up the
genre and themes of movies to help users decide if they want to watch.
Respond in 50 words or fewer

## Output format

Plot outline: a 1 sentence description

Genre: movie genre (see choices below)

Setting: time and place

## Choices

Possible movie genres to choose from: Action, Comedy, Drama,
Horror, Science, Fiction, Thriller, Romance, Fantasy, Adventure, Documentary
"

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)

chat$chat("Summarise the movie: ", pride_synopsis)

## 4 - Iterate - be more strongly worded - prompt

prompt <- "You are a movie summariser whose job is to sum up the
genre and themes of movies to help users decide if they want to watch.
Respond in 50 words or fewer

## Output format

Plot outline: a 1 sentence description

Genre: movie genre (see choices below)

Setting: time and place

## Choices

You MUST only choose genres that appear on this list: Action, Comedy,
Drama,  Horror, Science, Fiction, Thriller, Romance, Fantasy, Adventure,
Documentary"

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)

chat$chat("Summarise the movie: ", pride_synopsis)

## Your turn

# 1. Pick a different movie from the movie dataset and run the "best"
#    version of the prompt on it
# 2. Update the prompt to also extract information about the movie's themes
# 3. See if you can update it to show what YOU would want to see in a summary
