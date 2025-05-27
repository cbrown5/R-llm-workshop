# Benthic Cover Analysis with Multidimensional Scaling (MDS)

## Introduction
This project analyzes benthic cover and fish survey data. We are particularly interested in how logging has degraded water quality, impacted benthic marine habitats, and how habitat loss in turn has impacted fish abundance. 
Our hypothesis is that sedimentation caused by logging has caused a loss in coral cover that is habitat for Topa, our fish species of interest. 

## Aims

1. Quantify the relationship between coral cover and topa abundance
2. Quantify the impact of distance to log ponds (loggin) on coral cover
3. Other aims TBD

## Data methodology

The benthic data was collected with the point intersect transect method. Divers swam along transects. There were several transects per site.  Along each transect they dropped points and recorded the type of benthic organism (in categories) on that point. Percentage cover for one organism type can then be calculated as the number of points with that organism divided by the total number of points on that transect.
Transects should be averaged to give a single value for each site. 
At each site divers also counted the number of Topa they say in a survey of standardized area. 

This data and study method is a simplified version of the study
[Brown, Hamilton. 2018. Estimating the footprint of pollution on coral reefs with models of species turnover. Conservation Biology. DOI: 10.1111/cobi.13079](http://onlinelibrary.wiley.com/doi/10.1111/cobi.13079/abstract), which should be cited. 

## Statistical methodology 

The fish data are counts so it will be most appropriate to use a negative binomial GLM to analyse the relationship between Topa and coral cover. We need to make sure to do appropriate verification checks of model quality. 

The coral cover data are counts of points out of a total number. So it will be most appropriate to use a binomial GLM when testing for the impact of distance to log ponds on coral cover. Again checks of fit/model quality are necessary. 

## Tech context
- We will use the R program
- tidyverse packages for data manipulation

Keep your scripts short and modular to facilitate debugging. Don't complete all of the steps below in one script. Finish scripts where it makes sense and save intermediate datasets. 

## Steps
TODO Copilot I need help with how to implement the analyses.  

## Progress

Not yet started


## Data 
The datasets are available from the web at the URLs below

## Directory structure

TODO

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

## fish-coral-cover-sites

![Site level covariates, fish and coral cover](https://raw.githubusercontent.com/cbrown5/R-llm-workshop/refs/heads/main/resources/fish-coral-cover-sites.csv)

Variables
- site: Unique site IDs
- reeftype: Type of reef (e.g. intra-lagoon or lagoon)
- secchi: Secchi depth (m) a measure of water turbidity
- flow: Factor indicating if tidal flow was "Strong" or "Mild" at the site
- dist_to_logging_km: Distance to the nearest logging operation (km)
- pres.topa: Abundance of Topa on each survey
- CB_cover: Cover of branching coral cover (number of PIT points)
- n_pts: Number of PIT points for benthic cover. used to standardize cover calculations
- soft_cover: Soft coral cover (number PIT points)

