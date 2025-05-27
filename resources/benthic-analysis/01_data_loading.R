# Benthic Analysis Project - Step 1: Data Loading and Initial Exploration
# Author: [Your Name]
# Date: [Current Date]

# Load required packages
library(tidyverse)
library(readr)

# Create data directory if it doesn't exist
if (!dir.exists("data")) {
  dir.create("data")
}

# Define URLs for datasets
urls <- list(
  benthic_surveys = "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/BenthicCoverSurveys.csv",
  benthic_variables = "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/Benthic_Variables.csv",
  fish_coral_sites = "https://raw.githubusercontent.com/cbrown5/R-llm-workshop/refs/heads/main/resources/fish-coral-cover-sites.csv"
)

# Function to safely load data with error handling
load_dataset <- function(url, name) {
  cat("Loading", name, "from:", url, "\n")
  tryCatch({
    data <- read_csv(url, show_col_types = FALSE)
    cat("Successfully loaded", name, "- Dimensions:", nrow(data), "x", ncol(data), "\n")
    return(data)
  }, error = function(e) {
    cat("Error loading", name, ":", e$message, "\n")
    return(NULL)
  })
}

# Load all datasets
cat("=== Loading Datasets ===\n")
benthic_surveys <- load_dataset(urls$benthic_surveys, "Benthic Cover Surveys")
benthic_variables <- load_dataset(urls$benthic_variables, "Benthic Variables")
fish_coral_sites <- load_dataset(urls$fish_coral_sites, "Fish Coral Sites")

# Initial data exploration
cat("\n=== Initial Data Exploration ===\n")

# Benthic Cover Surveys
if (!is.null(benthic_surveys)) {
  cat("\n--- Benthic Cover Surveys ---\n")
  cat("Structure:\n")
  str(benthic_surveys)
  cat("\nFirst few rows:\n")
  print(head(benthic_surveys))
  cat("\nMissing values:\n")
  print(colSums(is.na(benthic_surveys)))
  cat("\nUnique sites:", length(unique(benthic_surveys$site)), "\n")
  cat("Unique organism codes:", length(unique(benthic_surveys$code)), "\n")
}

# Benthic Variables
if (!is.null(benthic_variables)) {
  cat("\n--- Benthic Variables ---\n")
  cat("Structure:\n")
  str(benthic_variables)
  cat("\nFirst few rows:\n")
  print(head(benthic_variables))
  cat("\nMissing values:\n")
  print(colSums(is.na(benthic_variables)))
  cat("\nUnique organism categories:", length(unique(benthic_variables$CATEGORY)), "\n")
}

# Fish Coral Sites
if (!is.null(fish_coral_sites)) {
  cat("\n--- Fish Coral Sites ---\n")
  cat("Structure:\n")
  str(fish_coral_sites)
  cat("\nFirst few rows:\n")
  print(head(fish_coral_sites))
  cat("\nMissing values:\n")
  print(colSums(is.na(fish_coral_sites)))
  cat("\nUnique sites:", length(unique(fish_coral_sites$site)), "\n")
  cat("\nReef types:", unique(fish_coral_sites$reeftype), "\n")
  cat("\nFlow categories:", unique(fish_coral_sites$flow), "\n")
}

# Data quality checks
cat("\n=== Data Quality Checks ===\n")

# Check for site overlap between datasets
if (!is.null(benthic_surveys) && !is.null(fish_coral_sites)) {
  benthic_sites <- unique(benthic_surveys$site)
  fish_sites <- unique(fish_coral_sites$site)
  
  cat("Sites in benthic surveys:", length(benthic_sites), "\n")
  cat("Sites in fish data:", length(fish_sites), "\n")
  cat("Overlapping sites:", length(intersect(benthic_sites, fish_sites)), "\n")
  cat("Sites only in benthic:", length(setdiff(benthic_sites, fish_sites)), "\n")
  cat("Sites only in fish:", length(setdiff(fish_sites, benthic_sites)), "\n")
}

# Check organism code matching
if (!is.null(benthic_surveys) && !is.null(benthic_variables)) {
  survey_codes <- unique(benthic_surveys$code)
  variable_codes <- unique(benthic_variables$CODE)
  
  cat("\nOrganism codes in surveys:", length(survey_codes), "\n")
  cat("Organism codes in variables:", length(variable_codes), "\n")
  cat("Matching codes:", length(intersect(survey_codes, variable_codes)), "\n")
  
  unmatched_survey <- setdiff(survey_codes, variable_codes)
  if (length(unmatched_survey) > 0) {
    cat("Unmatched codes in surveys:", paste(unmatched_survey, collapse = ", "), "\n")
  }
}

# Save datasets locally for reproducibility
cat("\n=== Saving Datasets ===\n")

if (!is.null(benthic_surveys)) {
  saveRDS(benthic_surveys, "data/benthic_surveys_raw.rds")
  cat("Saved benthic_surveys_raw.rds\n")
}

if (!is.null(benthic_variables)) {
  saveRDS(benthic_variables, "data/benthic_variables_raw.rds")
  cat("Saved benthic_variables_raw.rds\n")
}

if (!is.null(fish_coral_sites)) {
  saveRDS(fish_coral_sites, "data/fish_coral_sites_raw.rds")
  cat("Saved fish_coral_sites_raw.rds\n")
}

cat("\n=== Data Loading Complete ===\n")
cat("Proceed to step 2: Data Cleaning and Preparation\n")
