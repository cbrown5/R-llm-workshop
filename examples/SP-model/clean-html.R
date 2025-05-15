# HTML to XML Cleaning Script
# This script converts HTML files to simplified XML by removing unwanted elements
# Run from command line: 
# Rscript clean-html.R chpt7-sp-models-haddon.html chpt7-clean.xml
# Doesn't work yet
# Load required libraries
library(xml2)
library(rvest)

#' Clean HTML to Basic XML
#'
#' @param input_file Path to the HTML file to clean
#' @param output_file Path to save the cleaned XML file (optional)
#' @return XML document object
#'
clean_html_to_xml <- function(input_file, output_file = NULL) {
  # Read the HTML file
  html_content <- read_html(input_file)
  
  # Remove unwanted elements
  html_content %>%
    xml_find_all("//style") %>%
    xml_remove()
  
  html_content %>%
    xml_find_all("//meta") %>%
    xml_remove()
  
  html_content %>%
    xml_find_all("//link") %>%
    xml_remove()
  
  # Extract the body content
  html_content %>%
    xml_find_all("//head") %>%
    xml_remove()
  
  # Keep only desired elements (code, div, p, head, headings h1-h6)
  body_content <- html_content %>%
    xml_find_all("//body")
  
  # Create a new XML document with cleaned content
  cleaned_xml <- read_xml("<root></root>")
  
  # Find all elements we want to keep
  elements_to_keep <- xml_find_all(body_content, ".//code | .//div | .//p | .//h1 | .//h2 | .//h3 | .//h4 | .//h5 | .//h6")
  
  # Add them to our new XML root
  xml_root <- xml_find_first(cleaned_xml, "//root")
  for (element in elements_to_keep) {
    xml_add_child(xml_root, element)
  }
  
  # Save to file if output_file is specified
  if (!is.null(output_file)) {
    write_xml(cleaned_xml, output_file)
    cat("Cleaned XML saved to:", output_file, "\n")
  }
  
  return(cleaned_xml)
}

# Main function to run the script
main <- function() {
  args <- commandArgs(trailingOnly = TRUE)
  
  if (length(args) < 1) {
    cat("Usage: Rscript clean-html.R input_file.html [output_file.xml]\n")
    return(invisible(NULL))
  }
  
  input_file <- args[1]
  
  if (length(args) >= 2) {
    output_file <- args[2]
  } else {
    # Create default output filename by replacing html extension with xml
    output_file <- sub("\\.html$|\\.htm$", ".xml", input_file)
    if (output_file == input_file) {
      output_file <- paste0(input_file, ".xml")
    }
  }
  
  tryCatch({
    clean_html_to_xml(input_file, output_file)
  }, error = function(e) {
    cat("Error processing file:", e$message, "\n")
  })
}

# Run the main function if script is executed directly
if (!interactive()) {
  main()
}
