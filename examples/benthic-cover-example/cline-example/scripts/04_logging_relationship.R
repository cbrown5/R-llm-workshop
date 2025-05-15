# 04_logging_relationship.R
# Script to explore the relationship between benthic communities and distance to logging

# Load required packages
library(tidyverse)
library(vegan)  # For community analysis
library(ggrepel)  # For non-overlapping text labels

# Load the processed datasets
site_data_combined <- read_csv("data/site_data_combined.csv")
mds_data <- read_csv("data/mds_coordinates.csv")

# Extract benthic cover data (exclude site and covariates)
benthic_columns <- site_data_combined %>%
  select(-site, -reeftype, -secchi, -flow, -mindist)

# 1. Correlation between distance to logging and benthic cover
# Calculate correlation for each benthic category with distance to logging
correlations <- data.frame(
  benthic_code = names(benthic_columns),
  correlation = sapply(benthic_columns, function(x) cor(x, site_data_combined$mindist, method = "spearman"))
)

# Sort by absolute correlation value
correlations <- correlations %>%
  mutate(abs_correlation = abs(correlation)) %>%
  arrange(desc(abs_correlation))

# Save correlations
write_csv(correlations, "data/logging_correlations.csv")

# Plot top correlations
top_correlations <- correlations %>%
  slice_head(n = 10)

corr_plot <- ggplot(top_correlations, aes(x = reorder(benthic_code, abs_correlation), y = correlation)) +
  geom_col(aes(fill = correlation > 0)) +
  scale_fill_manual(values = c("firebrick", "steelblue"), 
                    labels = c("Negative", "Positive"),
                    name = "Correlation") +
  coord_flip() +
  theme_minimal() +
  labs(
    title = "Top 10 Benthic Categories Correlated with Distance to Logging",
    x = "Benthic Category Code",
    y = "Spearman Correlation"
  )

# Save the plot
ggsave("output/figures/logging_correlations.png", corr_plot, width = 8, height = 6, dpi = 300)

# 2. Fit environmental vectors to MDS ordination
# Create a data frame with the environmental variables
env_data <- site_data_combined %>%
  select(mindist, secchi)

# Fit environmental vectors to the MDS ordination
env_fit <- envfit(metaMDS(benthic_columns, distance = "bray"), env_data, perm = 999)

# Extract the environmental vectors for plotting
env_vectors <- as.data.frame(scores(env_fit, "vectors")) * 0.8  # Scale vectors for visibility
env_vectors$variable <- rownames(env_vectors)
env_vectors$pvalue <- env_fit$vectors$pvals

# Create MDS plot with environmental vectors
mds_env_plot <- ggplot(mds_data, aes(x = NMDS1, y = NMDS2)) +
  geom_point(aes(color = mindist), size = 3) +
  scale_color_viridis_c(name = "Distance to\nLogging (m)") +
  geom_segment(data = env_vectors, 
               aes(x = 0, y = 0, xend = NMDS1, yend = NMDS2, 
                   linetype = pvalue < 0.05),
               arrow = arrow(length = unit(0.2, "cm")),
               color = "black") +
  geom_text_repel(data = env_vectors, 
                 aes(x = NMDS1, y = NMDS2, label = variable),
                 size = 4) +
  scale_linetype_manual(values = c("dashed", "solid"), 
                        labels = c("p ≥ 0.05", "p < 0.05"),
                        name = "Significance") +
  theme_minimal() +
  labs(
    title = "MDS Plot with Environmental Vectors",
    subtitle = "Showing relationship between benthic communities and environmental variables",
    x = "NMDS1",
    y = "NMDS2"
  )

# Save the plot
ggsave("output/figures/mds_env_vectors.png", mds_env_plot, width = 10, height = 8, dpi = 300)

# 3. Cluster analysis to identify potential groupings of sites
# Perform hierarchical clustering on the Bray-Curtis dissimilarity matrix
bray_curtis_dist <- vegdist(benthic_columns, method = "bray")
hclust_result <- hclust(bray_curtis_dist, method = "average")  # UPGMA clustering

# Determine optimal number of clusters using silhouette width
library(cluster)
max_k <- min(15, nrow(benthic_columns) - 1)
sil_width <- numeric(max_k - 1)

for (k in 2:max_k) {
  clusters <- cutree(hclust_result, k = k)
  sil <- silhouette(clusters, bray_curtis_dist)
  sil_width[k-1] <- mean(sil[, "sil_width"])
}

# Find optimal k (number of clusters)
optimal_k <- which.max(sil_width) + 1

# Cut the dendrogram to get the clusters
clusters <- cutree(hclust_result, k = optimal_k)

# Add cluster information to MDS data
mds_data$cluster <- as.factor(clusters)

# Create MDS plot with clusters
mds_cluster_plot <- ggplot(mds_data, aes(x = NMDS1, y = NMDS2, color = cluster)) +
  geom_point(size = 3) +
  stat_ellipse(aes(group = cluster), level = 0.95, linetype = 2) +
  scale_color_brewer(palette = "Set1", name = "Cluster") +
  theme_minimal() +
  labs(
    title = "MDS Plot with Site Clusters",
    subtitle = paste("Optimal number of clusters:", optimal_k),
    x = "NMDS1",
    y = "NMDS2"
  )

# Save the plot
ggsave("output/figures/mds_clusters.png", mds_cluster_plot, width = 8, height = 6, dpi = 300)

# 4. Analyze relationship between clusters and distance to logging
cluster_logging <- mds_data %>%
  group_by(cluster) %>%
  summarize(
    mean_dist_logging = mean(mindist, na.rm = TRUE),
    sd_dist_logging = sd(mindist, na.rm = TRUE),
    n = n(),
    .groups = "drop"
  )

# Save cluster summary
write_csv(cluster_logging, "data/cluster_logging_summary.csv")

# Create boxplot of distance to logging by cluster
cluster_boxplot <- ggplot(mds_data, aes(x = cluster, y = mindist, fill = cluster)) +
  geom_boxplot() +
  scale_fill_brewer(palette = "Set1", guide = "none") +
  theme_minimal() +
  labs(
    title = "Distance to Logging by Benthic Community Cluster",
    x = "Cluster",
    y = "Distance to Logging (m)"
  )

# Save the plot
ggsave("output/figures/cluster_logging_boxplot.png", cluster_boxplot, width = 8, height = 6, dpi = 300)

# Print summary of the analysis
cat("Relationship Analysis Summary:\n")
cat("Optimal number of clusters:", optimal_k, "\n\n")

cat("Cluster summary statistics for distance to logging:\n")
print(cluster_logging)

cat("\nTop benthic categories correlated with distance to logging:\n")
print(top_correlations)

cat("\nEnvironmental vector fitting results:\n")
print(env_fit)

cat("\nAnalysis of relationship between benthic communities and logging completed.\n")
cat("Results saved to the data and output directories.\n")
