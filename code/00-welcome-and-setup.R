# 0 - Welcome and Setup
# Using LLMs in R with ellmer - LatinR 2026

## Install the packages we'll use

install.packages(c("ellmer", "dplyr", "readr", "tidyr", "usethis"))

## Add your OpenRouter API key to .Renviron
## (you'll be given a key on the day; ask us if you haven't got one)

usethis::edit_r_environ()

# Add this line to the file that opens, save it, then restart R:
# OPENROUTER_API_KEY=your-key-here

## Check the key is picked up

Sys.getenv("OPENROUTER_API_KEY") != ""

## Check ellmer can talk to the provider

library(ellmer)
chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat("Say hello in one short sentence.")
