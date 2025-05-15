# 03_mds_analysis.R
# Script to calculate dissimilarity matrices and perform MDS analysis

# Load required packages
library(tidyverse)
library(vegan)  # For community analysis

# Load the processed dataset
site_data_combined <- read_csv("data/site_data_combined.csv")

# Extract just the benthic cover data (exclude site and covariates)
# Assuming the first column is 'site' and the last few columns are covariates
benthic_columns <- site_data_combined %>%
  select(-site, -reeftype, -secchi, -flow, -mindist)

# Calculate dissimilarity matrices
# 1. Euclidean distance
euclidean_dist <- vegdist(benthic_columns, method = "euclidean")
# 2. Bray-Curtis distance (commonly used for ecological community data)
bray_curtis_dist <- vegdist(benthic_columns, method = "bray")

# Save the distance matrices
write.csv(as.matrix(euclidean_dist), "data/euclidean_dist_matrix.csv")
write.csv(as.matrix(bray_curtis_dist), "data/bray_curtis_dist_matrix.csv")

# Perform MDS (Non-metric Multidimensional Scaling)
# Using Bray-Curtis as it's more appropriate for ecological data
mds_result <- metaMDS(benthic_columns, distance = "bray", k = 2, trymax = 100)

# Extract MDS coordinates
mds_coords <- as.data.frame(scores(mds_result))
mds_coords$site <- site_data_combined$site

# Add site covariates to MDS coordinates for visualization
mds_data <- mds_coords %>%
  left_join(site_data_combined %>% select(site, reeftype, secchi, flow, mindist), by = "site")

# Save MDS results
write_csv(mds_data, "data/mds_coordinates.csv")

# Create MDS plot
mds_plot <- ggplot(mds_data, aes(x = NMDS1, y = NMDS2, color = reeftype)) +
  geom_point(size = 3) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal() +
  labs(
    title = "MDS Plot of Benthic Cover Composition",
    subtitle = paste("Stress value:", round(mds_result$stress, 3)),
    x = "NMDS1",
    y = "NMDS2",
    color = "Reef Type"
  )

# Save the plot
ggsave("output/figures/mds_plot_reeftype.png", mds_plot, width = 8, height = 6, dpi = 300)

# Create another MDS plot with points colored by distance to logging
mds_plot_logging <- ggplot(mds_data, aes(x = NMDS1, y = NMDS2, color = mindist)) +
  geom_point(size = 3) +
  scale_color_viridis_c(name = "Distance to\nLogging (m)") +
  theme_minimal() +
  labs(
    title = "MDS Plot of Benthic Cover Composition",
    subtitle = paste("Stress value:", round(mds_result$stress, 3)),
    x = "NMDS1",
    y = "NMDS2"
  )

# Save the plot
ggsave("output/figures/mds_plot_logging.png", mds_plot_logging, width = 8, height = 6, dpi = 300)

# Print MDS summary
cat("MDS Analysis Summary:\n")
cat("Stress value:", mds_result$stress, "\n")
cat("Interpretation of stress value:\n")
if (mds_result$stress < 0.05) {
  cat("Excellent representation (< 0.05)\n")
} else if (mds_result$stress < 0.1) {
  cat("Good representation (< 0.1)\n")
} else if (mds_result$stress < 0.2) {
  cat("Fair representation (< 0.2)\n")
} else {
  cat("Poor representation (>= 0.2)\n")
}

cat("\nMDS analysis completed. Results saved to the data and output directories.\n")
