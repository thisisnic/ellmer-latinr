# 4 - Tool Calling
# Using LLMs in R with ellmer - LatinR 2026

# Define the function
sample_movies <- function() {
  read.csv("data/movies_with_genres.csv") |>
    slice_sample(n = 1)
}

# Create tool
sample_movies_tool <- tool(
  sample_movies,
  description = "Randomly sample a movie from the dataset"
)

## Initialise a chat and register the tool

prompt <- "You are a movie recommender bot designed to help users
pick potential films to add to their watch list. Sample a
random film and give the user a 20 word summary of it."

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)

chat$register_tool(sample_movies_tool)

## Use the tool!

chat$chat("What movie should I watch this weekend?")

## Update the function to filter the data

movie_genres <- c(
  "Action", "Comedy", "Drama", "Horror",
  "Science Fiction", "Thriller", "Romance",
  "Fantasy", "Adventure", "Documentary"
)

sample_and_filter_movies <- function(genre_choice = movie_genres) {
  read.csv("data/movies_with_genres.csv") |>
    filter(genre %in% genre_choice) |>
    slice_sample(n = 1)
}

## Define tool using updated function

sample_and_filter_movies_tool <- tool(
  sample_and_filter_movies,
  description = "Randomly sample a movie from the dataset",
  arguments = list(
    genre_choice = type_array(
      type_enum(
        values = movie_genres,
        "Movie genres to choose from"
      )
    )
  )
)

## Register the updated tool

prompt <- "You are a movie recommender bot designed to help users
pick potential films to add to their watch list. Sample a
random film and give the user a 20 word summary of it.
"

chat <- chat_openrouter(
  model = "openai/gpt-6.1-terra",
  system_prompt = prompt
)

chat$register_tool(sample_and_filter_movies_tool)

## Ask the question

live_console(chat)

# What movie should I watch tonight? I like scifi!

## Your turn

# 1. Try using the tool and ask different questions and see if you can get
#    the LLM to call it repeatedly
