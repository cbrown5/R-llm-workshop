# 00_install_packages.R
# Script to install required packages for the benthic cover analysis project

# List of required packages
required_packages <- c(
  "tidyverse",  # For data manipulation and visualization
  "vegan",      # For community analysis
  "ggplot2",    # For data visualization
  "ggrepel",    # For non-overlapping text labels
  "cluster",    # For cluster analysis
  "knitr",      # For report generation
  "kableExtra"  # For table formatting in reports
)

# Function to check and install packages
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    cat(paste0("Installing package: ", pkg, "\n"))
    install.packages(pkg, dependencies = TRUE)
  } else {
    cat(paste0("Package already installed: ", pkg, "\n"))
  }
}

# Install missing packages
cat("Checking and installing required packages...\n")
for (pkg in required_packages) {
  install_if_missing(pkg)
}

# Load the packages to verify installation
cat("\nLoading packages to verify installation...\n")
for (pkg in required_packages) {
  cat(paste0("Loading package: ", pkg, "\n"))
  library(pkg, character.only = TRUE)
}

cat("\nAll required packages are installed and loaded.\n")
cat("You can now proceed with running the analysis scripts.\n")
