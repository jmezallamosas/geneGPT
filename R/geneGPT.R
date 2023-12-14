# Libraries
library(httr2)

# Function
gene_annotation <- function(genes) {
  answer = list()
  for (gene in genes) {
    api_key = Sys.getenv("OPENAI_API_KEY")
    user_message = list(
      list(role = "system", content = "You are an expert biologist and specialize in providing clear, concise answers."),
      list(role = "user", content = paste("Answer the following question as accurately as you can. If you don't know, say you do not know. Do not try to make up an answer.
           Question: Explain in a sentence the main function in an oncology perspective of the following gene: ", gene))
      )
    base_url = "https://api.openai.com/v1"
    body = list(model = "gpt-4",
               messages = user_message)
    req = httr2::request(base_url)
    resp =
      req |> 
      httr2::req_url_path_append("chat/completions") |> 
      httr2::req_auth_bearer_token(token = api_key) |> 
      httr2::req_headers("Content-Type" = "application/json") |> 
      httr2::req_user_agent("Jose Meza Llamosas @jmezallamosas | Revolution Medicines") |> 
      httr2::req_body_json(body) |> 
      httr2::req_retry(max_tries = 4) |>
      httr2::req_perform()
    
    openai_chat_response = resp |> httr2::resp_body_json(simplifyVector = TRUE)
    
    answer[[gene]] = openai_chat_response$choices$message$content
  }
  return(answer)
}

markers <- function(process, number_genes) {
  answer = list()
  api_key = Sys.getenv("OPENAI_API_KEY")
  user_message = list(
      list(role = "system", content = "You are an expert biologist and specialize in providing clear, concise answers."),
      list(role = "user", content = paste("Answer the following question as accurately as you can. If you don't know, say you do not know. Do not try to make up an answer.
           Question: Give a list separated by bullet points of ", number_genes, " genes associated as markers of ", process, " in an oncology perspective. Provide a once sentence description for each gene selected." ))
  )
  base_url = "https://api.openai.com/v1"
  body = list(model = "gpt-4",
                messages = user_message)
  req = httr2::request(base_url)
  resp =
    req |> 
    httr2::req_url_path_append("chat/completions") |> 
    httr2::req_auth_bearer_token(token = api_key) |> 
    httr2::req_headers("Content-Type" = "application/json") |> 
    httr2::req_user_agent("Jose Meza Llamosas @jmezallamosas | Revolution Medicines") |> 
    httr2::req_body_json(body) |> 
    httr2::req_retry(max_tries = 4) |>
    httr2::req_perform()
    
  openai_chat_response = resp |> httr2::resp_body_json(simplifyVector = TRUE)
    
  description = openai_chat_response$choices$message$content
  description = unlist(strsplit(description, "• "))
  
  for (sentence in description[2:length(description)]){
    gene = gregexec("\\([A-Z]{2}.*?\\)", sentence)
    gene = regmatches(sentence, gene)[[1]][1]
    gene = gsub("\\(|\\)","", gene)
    answer[[gene]] = sentence
  }
  
  return(answer)
}

chat <- function(question) {
  api_key = Sys.getenv("OPENAI_API_KEY")
  user_message = list(
    list(role = "system", content = "You are an expert biologist and specialize in providing clear, concise answers."),
    list(role = "user", content = paste("Answer the following question as accurately as you can. If you don't know, say you do not know. Do not try to make up an answer.
         Question: ", question))
  )
  base_url = "https://api.openai.com/v1"
  body = list(model = "gpt-4",
              messages = user_message)
  req = httr2::request(base_url)
  resp =
    req |> 
    httr2::req_url_path_append("chat/completions") |> 
    httr2::req_auth_bearer_token(token = api_key) |> 
    httr2::req_headers("Content-Type" = "application/json") |> 
    httr2::req_user_agent("Jose Meza Llamosas @jmezallamosas | Revolution Medicines") |> 
    httr2::req_body_json(body) |> 
    httr2::req_retry(max_tries = 4) |>
    httr2::req_perform()
    
  openai_chat_response = resp |> httr2::resp_body_json(simplifyVector = TRUE)
    
  answer = openai_chat_response$choices$message$content
  
  return(answer)
}



add_openai_key_to_renv <- function(key_value, force = FALSE) {
  # Specify the path to the .Renviron file
  renv_file <- file.path(Sys.getenv("HOME"), ".Renviron")
  
  # Check if the file exists
  if (file.exists(renv_file)) {
    # Read the content of the existing file
    renv_content <- readLines(renv_file)
    
    # Check if the OPENAI_KEY variable already exists
    key_exists <- any(grepl("OPENAI_API_KEY=", renv_content))
    
    # Check if force is TRUE or the key doesn't exist
    if (force || !key_exists) {
      
      # Remove existing OPENAI_KEY variable if it exists
      if (key_exists) {
        renv_content <- renv_content[!grepl("OPENAI_API_KEY=", renv_content)]
        
        # Overwrite the OPENAI_KEY variable to the file
        sep_renv_content = unlist(strsplit(renv_content, split=" "))
        cat(sep_renv_content[1], file = renv_file, append = FALSE)
        cat("\n", file = renv_file, append = TRUE)
        
        for (content in sep_renv_content[2:length(sep_renv_content)]){
          cat(content, file = renv_file, append = TRUE)
          cat("\n", file = renv_file, append = TRUE)
        }
      } 
      
      # Append the OPENAI_KEY variable to the file
      cat(paste0("OPENAI_API_KEY=", key_value), file = renv_file, append = TRUE)
      cat("\n", file = renv_file, append = TRUE)
      
      # Print a message indicating success
      print("OPENAI_API_KEY added to .Renviron successfully.")
      
    } else {
      # Print a message indicating that OPENAI_KEY already exists
      print("OPENAI_API_KEY already exists in .Renviron. To force redefinition, set force = TRUE.")
    }
  } else {
    # Print a message indicating that the .Renv file doesn't exist
    print(".Renviron file not found. Please create the .Renviron file first.")
  }
}



