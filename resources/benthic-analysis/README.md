# Benthic Cover Analysis with Multidimensional Scaling (MDS)

## Introduction
This project analyzes benthic cover surveys to visualize patterns in ecological communities across different sites. Multidimensional Scaling (MDS) will be used to reduce the dimensionality of the data and reveal underlying patterns in site dispersion. We are particularly interested in how community structure relates to distance to logging. 
Our hypothesis is that sedimentation caused by logging has impact coral cover. 

## Aims

1. Quantify the relationship between coral cover and topa abundance
2. ...

## Data methodology

The data was collected with the point intersect transect method. Divers swam along transects. There were several transects per site.  Along each transect they dropped points and recorded the type of benthic organism (in categories) on that point. Percentage cover for one organism type can then be calculated as the number of points with that organism divided by the total number of points on that transect.
Transects should be averaged to give a single value for each site. 

This data and study method is a simplified version of the study
[Brown, Hamilton. 2018. Estimating the footprint of pollution on coral reefs with models of species turnover. Conservation Biology. DOI: 10.1111/cobi.13079](http://onlinelibrary.wiley.com/doi/10.1111/cobi.13079/abstract), which should be cited. 


## Tech context
- We will use the R program
- tidyverse packages for data manipulation

Keep your scripts short and modular to facilitate debugging. Don't complete all of the steps below in one script. Finish scripts where it makes sense and save intermediate datasets. 

## Steps
TODO

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

