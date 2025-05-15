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


## Tech context
- We will use the R program
- tidyverse packages for data manipulation
- vegan package for community analysis
- ggplot2 for data visualization

Keep your scripts short and modular to facilitate debugging. Don't complete all of the steps below in one script. Finish scripts where it makes sense and save intermediate datasets. 

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

## Data 
The datasets are available from the web at the URLs below


### BenthicCoverSurveys

![Benthic cover survey data in long format](https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/BenthicCoverSurveys.csv")

Variables
- site: Unique site IDs
- trans: transect numbers, there are multiple transects per site
- code: benthic organism code
- cover: Number of 
- n.pts: number of points sampled 

## Benthic_Variables

![Database linking benthic codes to full names](https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/Benthic_Variables.csv)

Variables
- CODE: benthic organism code, matches `code` in BenthicCoverSurveys
- CATEGORY: Long format name of benthic organism

## JuvUVCSites_with_ReefTypes_16Jun2016

![Site level covariates](https://raw.githubusercontent.com/cbrown5/BenthicLatent/refs/heads/master/data-raw/JuvUVCSites_with_ReefTypes_16Jun2016.csv)

Variables
- site: Unique site IDs
- reeftype: Type of reef (e.g. intra-lagoon or lagoon)
- secchi: Secchi depth (m) a measure of water turbidity
- flow: Factor indicating if tidal flow was "Strong" or "Mild" at the site
- mindist: Distance to the nearest logging operation (m)

## Examples

### Example: ggplot of Points Using ColorBrewer2

Below is an example of how to create a scatter plot using `ggplot2` with a ColorBrewer2 palette for coloring points by a categorical variable.

```r
# Load required libraries
library(ggplot2)

# Create the plot
ggplot(data, aes(x = MDS1, y = MDS2, color = site)) +
    geom_point(size = 3) +
    scale_color_brewer(palette = "Set1") +
    theme_minimal() +
    labs(
        title = "MDS Plot of Benthic Cover Composition",
        x = "Axis 1",
        y = "Axis 2",
        color = "Site"
    )
```