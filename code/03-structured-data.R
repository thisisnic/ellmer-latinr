# 3 - Extracting Structured Data
# Using LLMs in R with ellmer - LatinR 2026

library(ellmer)
library(dplyr)

dogs <- readr::read_csv("data/dogs.csv")

dog_description <- dogs |>
  slice(1) |>
  pull(description)

## The problem with unstructured output

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
output <- chat$chat(
  "Extract the name and adoption fee from this data

  ## Output format

  Name:
  Adoption fee:",
  dog_description
)
output
class(output)

## Extracting a single value

name_type <- type_string("The name of the dog")

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = name_type)

## Extracting a number

fee_type <- type_number("Adoption fee in dollars")

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = fee_type)

## Constraining to specific choices

age_groups <- c("Baby", "Young", "Adult", "Senior")

age_type <- type_enum(age_groups, "Age group of the dog")

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = age_type)

## Extracting a yes/no

other_dogs_type <- type_boolean(
  "Is the dog recommended for a home with other dogs?"
)

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = other_dogs_type)

## Extracting a list of values

likes_type <- type_array(type_string("Things the dog likes"))

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = likes_type)

## Combining multiple fields

dog_spec <- type_object(
  name = type_string("The name of the dog"),
  breed = type_string("Breed of the dog"),
  adoption_fee = type_number("Adoption fee in dollars"),
  other_dogs = type_boolean(
    "Is the dog recommended for a home with other dogs?",
  ),
  age = type_enum(age_groups, "Age group of the dog")
)

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat_structured(dog_description, type = dog_spec)

## Processing multiple dogs

prompts <- paste("Extract data from this dog adoption listing:", dogs$description)

prompts

# parallel_chat_structured is a little different
output <- parallel_chat_structured(
  chat = chat_openrouter(model = "anthropic/claude-haiku-5.5"),
  prompts = as.list(prompts),
  type = dog_spec
)

output

## Combining them

dogs_details <- bind_cols(dogs, output)
dogs_details

## Save to a file

readr::write_csv(dogs_details, "data/dogs_details.csv")

## Your turn

# 1. Pick a different dog from the dataset
# 2. Extract the name and age group using chat_structured()
# 3. Process all dogs using parallel_chat_structured()
# 4. Bonus: Add a new field for the dog's energy level using type_enum() with
#    choices like "Low", "Medium", "High"
