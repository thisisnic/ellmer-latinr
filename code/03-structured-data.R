# 3 - Extracting Structured Data
# Using LLMs in R with ellmer - LatinR 2026

## The problem with unstructured output

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
output <- chat$chat(
  "Extract year and location from this data

  ## Output format

  Year:
  Location",
  pride_synopsis
)
output
class(output)

## Extracting a single value

year_type <- type_integer("Year the movie is set in")

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat_structured(pride_synopsis, type = year_type)

## Extracting text

location_type <- type_string("Primary location of the movie")

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat_structured(pride_synopsis, type = location_type)

## Constraining to specific choices

movie_genres <- c(
  "Action", "Comedy", "Drama", "Horror",
  "Science Fiction", "Thriller", "Romance",
  "Fantasy", "Adventure", "Documentary"
)

genre_type <- type_enum(movie_genres, "The genre of the movie")

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat_structured(pride_synopsis, type = genre_type)

## Extracting text

location_type <- type_array(type_string("locations of the movie"))

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat_structured(pride_synopsis, type = location_type)

## Combining multiple fields

year_type <- type_integer("Year the movie is set in")
genre_type <- type_enum(movie_genres, "The genre of the movie")

movie_info_type <- type_object(
  year_set = year_type,
  genre = genre_type
)

chat <- chat_openrouter(model = "openai/gpt-6.1-terra")
chat$chat_structured(pride_synopsis, type = movie_info_type)

## Processing multiple movies

prompts <- paste("Extract data from this movie synopsis:", movies$synopsis)

prompts

# parallel_chat_structured is a little different
output <- parallel_chat_structured(
  chat = chat_openrouter(model = "openai/gpt-6.1-terra"),
  prompts = as.list(prompts),
  type = movie_info_type
)

output

## Combining them

movies_with_genres <- bind_cols(movies, output)
movies_with_genres

## Save to a file
readr::write_csv(movies_with_genres, "data/movies_with_genres.csv")

## Your turn

# 1. Pick a different movie from the dataset
# 2. Extract the year and genre using chat_structured()
# 3. Process all movies using parallel_chat_structured()
# 4. Bonus: Add a new field for the movie's tone using type_enum() with
#    choices like "Uplifting", "Dark", "Comedic", "Bittersweet"
