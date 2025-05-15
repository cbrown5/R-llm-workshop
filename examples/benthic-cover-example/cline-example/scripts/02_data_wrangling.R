# 02_data_wrangling.R
# Script to wrangle benthic cover data

# Load required packages
library(tidyverse)

# Load the imported datasets
benthic_cover <- read_csv("data/benthic_cover.csv")
benthic_variables <- read_csv("data/benthic_variables.csv")
site_covariates <- read_csv("data/site_covariates.csv")

# Standardize column names
benthic_variables <- benthic_variables %>%
  rename(code = CODE, category = CATEGORY)

# Calculate percentage cover for each organism type per transect
# Percentage cover = number of points with organism / total number of points on transect
benthic_percent <- benthic_cover %>%
  # Calculate percentage cover
  mutate(percent_cover = (cover / n.pts) * 100) %>%
  # Join with benthic_variables to get full category names
  left_join(benthic_variables, by = "code")

# Average transects to get a single value for each site and organism type
site_avg_cover <- benthic_percent %>%
  group_by(site, code, category) %>%
  summarize(
    mean_percent_cover = mean(percent_cover, na.rm = TRUE),
    .groups = "drop"
  )

# Create a wide format dataset for multivariate analysis
# Each row is a site, each column is an organism type
site_wide_cover <- site_avg_cover %>%
  pivot_wider(
    id_cols = site,
    names_from = code,
    values_from = mean_percent_cover,
    values_fill = 0  # Fill missing values with 0
  )

# Join with site covariates
site_data_combined <- site_wide_cover %>%
  left_join(site_covariates, by = "site")

# Save the processed datasets
write_csv(benthic_percent, "data/benthic_percent.csv")
write_csv(site_avg_cover, "data/site_avg_cover.csv")
write_csv(site_data_combined, "data/site_data_combined.csv")

# Display summary of the combined dataset
cat("Combined dataset summary:\n")
glimpse(site_data_combined)
cat("\nNumber of sites:", nrow(site_data_combined), "\n")
cat("Number of benthic categories:", ncol(site_wide_cover) - 1, "\n")

cat("\nData wrangling completed. Processed datasets saved to the data directory.\n")
