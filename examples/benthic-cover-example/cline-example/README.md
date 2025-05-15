# Benthic Cover Analysis with Multidimensional Scaling (MDS)

This project analyzes benthic cover surveys to visualize patterns in ecological communities across different sites, with a focus on how community structure relates to distance to logging operations.

## Project Structure

```
.
├── README.md                 # Project overview and instructions
├── data/                     # Data directory for imported and processed datasets
├── output/                   # Output directory for results
│   └── figures/              # Directory for saved plots and visualizations
└── scripts/                  # R scripts for analysis
    ├── 00_install_packages.R # Script to install required packages
    ├── 01_import_data.R      # Script to import datasets
    ├── 02_data_wrangling.R   # Script for data wrangling
    ├── 03_mds_analysis.R     # Script for MDS analysis
    ├── 04_logging_relationship.R # Script to analyze relationship with logging
    ├── 05_final_report.Rmd   # R Markdown report summarizing findings
    └── run_all.R             # Script to run the entire analysis pipeline
```

## Requirements

This project requires R with the following packages:
- tidyverse
- vegan
- ggplot2
- ggrepel
- cluster
- knitr
- kableExtra

## How to Run the Analysis

### Option 1: Run All Scripts at Once

You can run the entire analysis pipeline with a single command:

```
Rscript scripts/run_all.R
```

This script will execute all the analysis steps in sequence and generate the final report.

### Option 2: Run Scripts Individually

Alternatively, you can run each script individually in sequence:

1. **Install Required Packages**:
   ```
   Rscript scripts/00_install_packages.R
   ```
   This script checks for and installs any missing required packages.

2. **Import Data**: 
   ```
   Rscript scripts/01_import_data.R
   ```
   This script imports the datasets from the web and saves them to the data directory.

3. **Data Wrangling**: 
   ```
   Rscript scripts/02_data_wrangling.R
   ```
   This script processes the data, calculates percentage cover, and prepares the data for analysis.

4. **MDS Analysis**: 
   ```
   Rscript scripts/03_mds_analysis.R
   ```
   This script performs MDS analysis and creates visualizations of site dispersion.

5. **Logging Relationship Analysis**: 
   ```
   Rscript scripts/04_logging_relationship.R
   ```
   This script explores the relationship between benthic communities and distance to logging.

6. **Generate Final Report**: 
   ```
   Rscript -e "rmarkdown::render('scripts/05_final_report.Rmd', output_file = '../output/benthic_cover_analysis_report.html')"
   ```
   This command renders the R Markdown report to an HTML file in the output directory.

## Data Sources

The analysis uses three datasets:
1. BenthicCoverSurveys: Survey data in long format
2. Benthic_Variables: Links benthic codes to full names
3. JuvUVCSites_with_ReefTypes_16Jun2016: Site-level covariates

These datasets are automatically downloaded from the web when running the first script.

## Citation

This analysis is based on the methodology described in:
Brown, Hamilton. 2018. Estimating the footprint of pollution on coral reefs with models of species turnover. Conservation Biology. DOI: 10.1111/cobi.13079
