# Benthic Cover Analysis with Multidimensional Scaling (MDS)

## Introduction
This project analyzes benthic cover surveys to visualize patterns in ecological communities across different sites. Multidimensional Scaling (MDS) will be used to reduce the dimensionality of the data and reveal underlying patterns in site dispersion. We are particularly interested in how community structure relates to distance to logging. 
Our hypothesis is that sedimentation caused by logging has impact coral cover. 

## Aims

1. Visualize patterns in benthic cover composition across sites
2. Identify potential groupings of sites based on benthic cover composition
3. Relate ecological communities to logging

## Data methodology

The data was collected with the point intersect transect method. Divers swam along transects. There were several transects per site.  Along each transect they dropped points and recorded the type of benthic organism (in categories) on that point. Percentage cover for one organism type can then be calculated as the number of points with that organism divided by the total number of points on that transect.
Transects should be averaged to give a single value for each site. 

This data and study method is a simplified version of the study
[Brown, Hamilton. 2018. Estimating the footprint of pollution on coral reefs with models of species turnover. Conservation Biology. DOI: 10.1111/cobi.13079](http://onlinelibrary.wiley.com/doi/10.1111/cobi.13079/abstract), which should be cited. 


## Analysis methodology 

We'll use non-metric multidimensional scaling (nMDS) to represent patterns in community structure across sites. Site dispersion will be visualized with a 2D ordination. Be sure to show the 'stress' statistic on the figure, this is critical for interpretation. The nMDS will be created twice using two distance measures: Euclidean distance and Bray-Curtis distance. 
We'll test for relationships among community structure and distance to logging using the `envfit()` algorithm from the `vegan` package. 

## Tech context
- We will use the R program
- tidyverse packages for data manipulation
- vegan package for community analysis
- ggplot2 for data visualization

Keep your scripts short and modular to facilitate debugging. Don't complete all of the steps below in one script. Finish scripts where it makes sense and save intermediate datasets. 

When using Rscript to run R scripts in terminal put quotes around the file, e.g. `Rscript "1_data-input.R"`

## Steps
As you go tick of the steps below. 

[ ]  Import the datasets
[ ] Wrangle data to make a combined dataset
[ ] Calculate dissimilarity matrices based on benthic cover composition. Here we will use Euclidean and Bray-Curtis distances
[ ] Perform MDS analysis to visualize site dispersion in ordination space
[ ] Identify ecological patterns and potential groupings of sites
[ ] Assess the stress value to determine the reliability of the MDS representation
[ ] Explore how ecological communities relate to distance to logging 
[ ] Write an Rmd report summarizing the findings

As you go, document the methodology. Be sure to output both figures (as png files) and numbers that can be used in the final report.


## Meta data 

The datasets are available at the URLs below

### benthic_cover.csv

[Benthic cover survey data in long format](https://raw.githubusercontent.com/cbrown5/example-ecological-data/refs/heads/main/data/benthic-reefs-and-fish/benthic_cover.csv)


Variables
- site: Unique site IDs
- trans: transect numbers, there are multiple transects per site
- code: benthic organism code
- cover: Number of points belonging to this habitat type
- n.pts: Total number of points sampled on the transect, used to normalize `Cover` to get per cent cover. 

## benthic_variables.csv

[Database linking benthic codes to full names](https://raw.githubusercontent.com/cbrown5/example-ecological-data/refs/heads/main/data/benthic-reefs-and-fish/benthic_variables.csv)

Variables
- code: benthic organism code, matches `Code` in benthic_cover
- category: Long format name of benthic organism

## fish-coral-cover-sites.csv

![Site level covariates](https://raw.githubusercontent.com/cbrown5/example-ecological-data/refs/heads/main/data/benthic-reefs-and-fish/fish-coral-cover-sites.csv)

Variables
- site: Unique site IDs, use to join to benthic_cover.csv
- reef.ID: Unique reef ID
- pres.topa: number of Topa counted (local name for Bolbometopon)
- pres.habili: number of Habili counted (local name for Cheilinus) 
- secchi: Horizontal secchi depth (m), higher values mean the water is less turbid
- flow: Factor indicating if tidal flow was "Strong" or "Mild" at the site
- logged: Factor indicating if the site was in a region with logging "Logged" or without logging "Not logged"
- coordx: X coordinate in UTM zone 57S
- coordy: Y coordinate in UTM zone 57S
- cb_cover: Number of PIT points for branching coral cover
- soft_cover: Number of PIT points for soft coral cover
- n_pts: Number of PIT points at this site (for normalizing cover to get per cent cover)
- dist_to_logging_km: Linear distance to nearest log pond (site where logging occurs) in kilometres. 