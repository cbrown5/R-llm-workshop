# 01_import_data.R
# Script to import benthic cover datasets

# Load required packages
library(tidyverse)

# Define URLs for the datasets
benthic_cover_url <- "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/BenthicCoverSurveys.csv"
benthic_variables_url <- "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/Benthic_Variables.csv"
site_covariates_url <- "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/JuvUVCSites_with_ReefTypes_16Jun2016.csv"

# Import datasets
benthic_cover <- read_csv(benthic_cover_url)
benthic_variables <- read_csv(benthic_variables_url)
site_covariates <- read_csv(site_covariates_url)

# Display basic information about the datasets
cat("Benthic Cover Surveys dataset:\n")
glimpse(benthic_cover)
cat("\nBenthic Variables dataset:\n")
glimpse(benthic_variables)
cat("\nSite Covariates dataset:\n")
glimpse(site_covariates)

# Save the imported datasets to the data directory
write_csv(benthic_cover, "data/benthic_cover.csv")
write_csv(benthic_variables, "data/benthic_variables.csv")
write_csv(site_covariates, "data/site_covariates.csv")

cat("\nDatasets imported and saved to the data directory.\n")
