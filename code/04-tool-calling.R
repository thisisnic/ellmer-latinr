# 4 - Tool Calling
# Using LLMs in R with ellmer - LatinR 2026

library(ellmer)

## Without a tool the model can't know...

chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$chat("what's the time and date right now?")

## Your own R function as a tool

# Define the function
get_time <- function() {
  format(Sys.time(), "%A %d %B %Y, %H:%M")
}

# Create tool
time_tool <- tool(get_time, "Get the current date and time")

# Register the tool with the chat, then ask again
chat$register_tool(time_tool)
chat$chat("what's the time and date right now?")

# The tool call is part of the conversation
chat

# How it works: the assistant turn requests the tool, ellmer runs the R
# function and sends the result back as a user turn
chat$get_turns()

## Your turn (1)

# 1. Write an R function that returns something the model can't know - e.g.
#    a random number with sample(), or how many rows are in dogs
# 2. Turn it into a tool with tool() and register it with a chat
# 3. Ask a question that needs it, then print the chat to see the tool call

## Giving the model our dog data

# We don't always need a tool - sometimes we can just send the data
chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")

chat$chat(
  "I live in a small flat and already have a dog. Which three would suit me?",
  "Here are the dogs available:",
  content_document_file("data/dogs_details.csv")
)

## A tool that changes things: save a shortlist to a file

# Define the function - it returns a string describing what it did
save_shortlist <- function(names) {
  path <- "dog_shortlist.txt"
  if (file.exists(path)) {
    stop("File already exists, please choose a different path")
  }
  writeLines(names, path)
  paste("Saved", length(names), "dogs to", path)
}

# Create tool - this time with an argument the model has to supply
save_shortlist_tool <- tool(
  save_shortlist,
  "Save a shortlist of dog names to a text file",
  arguments = list(
    names = type_array(type_string("Dog names"))
  )
)

chat$register_tool(save_shortlist_tool)
chat$chat("Save the recommended dogs to the shortlist")

readLines("dog_shortlist.txt")

# The file already exists, so the function errors. The error message goes
# back to the model as the tool result
chat$chat("Save me 2 more random dogs to the shortlist")

## Should the model be allowed to do that?

# Checking the time just reads something. Saving a file changes something on
# our machine, and we might want a say in that. Annotations let us describe
# what each tool does...
time_tool <- tool(
  get_time,
  "Get the current date and time",
  annotations = tool_annotations(read_only_hint = TRUE)
)

save_shortlist_tool <- tool(
  save_shortlist,
  "Save a shortlist of dog names to a text file",
  arguments = list(
    names = type_array(type_string("Dog names"))
  ),
  annotations = tool_annotations(read_only_hint = FALSE)
)

# Don't forget to delete the shortlist from earlier!
file.remove("dog_shortlist.txt")

# ...and on_tool_request() runs before every tool call. Return nothing to
# allow it, or call tool_reject() to block it.
chat <- chat_openrouter(model = "anthropic/claude-haiku-5.5")
chat$register_tool(time_tool)
chat$register_tool(save_shortlist_tool)

chat$on_tool_request(function(request) {
  # Read-only tools go straight through
  if (isTRUE(request@tool@annotations$read_only_hint)) {
    return()
  }

  cat("The model wants to run", request@name, "with arguments:\n")
  str(request@arguments)

  answer <- readline("Allow? (y/n) ")
  if (tolower(answer) != "y") {
    tool_reject("The user declined when asked for approval")
  }
})

# Read-only tools don't trigger the question
chat$chat("What's the time?")

# Answer "n" when asked - the model is told why, and carries on gracefully
chat$chat(
  "Pick two random adult dogs and save them to the shortlist",
  "Here are the dogs available:",
  content_document_file("data/dogs_details.csv")
)
file.exists("dog_shortlist.txt")

## Your turn (2)

# 1. Ask the assistant to save a shortlist again, and approve it this time
#    (delete dog_shortlist.txt first!)
# 2. Change the rule in on_tool_request() so saving is allowed without asking
#    when it's 3 dogs or fewer
# 3. Bonus: log every tool call (name and arguments) to a data frame using
#    on_tool_request(), so you can see what the model did during a chat
