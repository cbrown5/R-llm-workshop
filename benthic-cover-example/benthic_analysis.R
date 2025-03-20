# Benthic Cover Analysis with Multidimensional Scaling (MDS)
# This script follows the steps outlined in benthic-readme.md

# Load required packages
library(tidyverse)  # For data manipulation
library(vegan)      # For ecological analysis including MDS
library(ggplot2)    # For visualization

# Step 1: Import and clean benthic cover survey data
# Data URL from GitHub
data_url <- "https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/BenthicCoverSurveys.csv"

# Import data
benthic_data <- read_csv(data_url)

# Examine the data structure
print("Data structure:")
str(benthic_data)
print("Summary of data:")
summary(benthic_data)

# Check for missing values
print("Missing values in each column:")
colSums(is.na(benthic_data))

# Clean data if necessary
benthic_data_clean <- benthic_data %>%
  # Convert site and trans to factors
  mutate(site = as.factor(site),
         trans = as.factor(trans),
         code = as.factor(code))

# Step 2: Calculate dissimilarity matrices
# First, we need to reshape the data to a wide format where:
# - Rows are sites/transects
# - Columns are benthic cover codes
# - Values are cover percentages

# Create a unique identifier for each site-transect combination
benthic_wide <- benthic_data_clean %>%
  mutate(site_trans = paste(site, trans, sep="_")) %>%
  select(site_trans, code, cover) %>%
  pivot_wider(names_from = code, values_from = cover, values_fill = 0)

# Extract site information for later use
site_info <- benthic_data_clean %>%
  mutate(site_trans = paste(site, trans, sep="_")) %>%
  select(site_trans, site, trans) %>%
  distinct()

# Extract the community data matrix (just the cover values)
community_matrix <- benthic_wide %>%
  select(-site_trans) %>%
  as.matrix()

# Calculate Bray-Curtis dissimilarity matrix
bray_dist <- vegdist(community_matrix, method = "bray")

# Step 3: Perform MDS analysis
# Non-metric Multidimensional Scaling (NMDS)
set.seed(123)  # For reproducibility
nmds_result <- metaMDS(community_matrix, distance = "bray", k = 2, trymax = 100)

# Print NMDS results
print("NMDS Results:")
print(nmds_result)

# Step 4: Visualize site dispersion in ordination space
# Extract NMDS coordinates for sites
nmds_coords <- as.data.frame(scores(nmds_result, "sites"))
# Add site_trans column to match with site_info
nmds_coords$site_trans <- rownames(nmds_coords)

# Merge with site information
nmds_plot_data <- nmds_coords %>%
  left_join(site_info, by = "site_trans")

# Create MDS plot
mds_plot <- ggplot(nmds_plot_data, aes(x = NMDS1, y = NMDS2, color = site)) +
  geom_point(size = 3, alpha = 0.8) +
  stat_ellipse(aes(group = site), type = "t", linetype = 2) +
  theme_minimal() +
  labs(title = "NMDS Ordination of Benthic Cover Data",
       subtitle = paste("Stress =", round(nmds_result$stress, 3)),
       x = "NMDS1", y = "NMDS2") +
  theme(legend.title = element_blank())

# Display the plot
print(mds_plot)

# Step 5: Assess the stress value
cat("\nStress value:", nmds_result$stress, "\n")
cat("Interpretation of stress value:\n")
cat("< 0.05: Excellent representation\n")
cat("< 0.1: Good representation\n")
cat("< 0.2: Potentially useful representation\n")
cat("> 0.2: Poor representation, may be misleading\n")
cat("> 0.3: Very poor, random placement\n")

# Step 6: Explore environmental factors (if available)
# Since we don't have explicit environmental data in the provided dataset,
# we can examine which benthic cover types are driving the ordination

# Fit benthic cover types to the ordination
benthic_fit <- envfit(nmds_result, community_matrix, perm = 999)
print("Benthic cover types driving the ordination:")
print(benthic_fit)

# Create a plot with the fitted vectors
vec_coords <- as.data.frame(scores(benthic_fit, "vectors")) * 0.9
vec_coords$code <- rownames(vec_coords)

# Filter for significant vectors (p < 0.05)
sig_vec <- vec_coords[benthic_fit$vectors$pvals < 0.05, ]

# Add vectors to the plot if there are significant ones
if(nrow(sig_vec) > 0) {
  mds_plot_with_vectors <- mds_plot +
    geom_segment(data = sig_vec, 
                aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2),
                arrow = arrow(length = unit(0.2, "cm")), color = "darkgrey") +
    geom_text(data = sig_vec, 
              aes(x = NMDS1, y = NMDS2, label = code),
              size = 3, hjust = -0.2, color = "black")  # Fixed color to black instead of using site
  
  print(mds_plot_with_vectors)
}

# Additional analysis: Calculate and visualize species richness by site
species_richness <- benthic_data_clean %>%
  group_by(site) %>%
  summarize(richness = n_distinct(code))

richness_plot <- ggplot(species_richness, aes(x = site, y = richness)) +
  geom_bar(stat = "identity", fill = "steelblue") +
  theme_minimal() +
  labs(title = "Species Richness by Site",
       x = "Site", y = "Number of Benthic Cover Types")

print(richness_plot)

# Save the plots
ggsave("mds_plot.png", mds_plot, width = 10, height = 8)
if(exists("mds_plot_with_vectors")) {
  ggsave("mds_plot_with_vectors.png", mds_plot_with_vectors, width = 10, height = 8)
}
ggsave("richness_plot.png", richness_plot, width = 8, height = 6)

# Print a summary of the analysis
cat("\n=== Benthic Cover Analysis Summary ===\n")
cat("Total number of sites:", length(unique(benthic_data_clean$site)), "\n")
cat("Total number of transects:", length(unique(benthic_data_clean$site_trans)), "\n")
cat("Total number of benthic cover types:", length(unique(benthic_data_clean$code)), "\n")
cat("NMDS stress value:", round(nmds_result$stress, 3), "\n")
