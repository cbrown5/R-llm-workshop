# Lobster abundance forecasting

## Introduction

We'll develop time-series models to forecast rock lobster (*Jasus edwardsii*) abundance from annual diver surveys. 

## Aims

1. Forecast lobster abundance
2. Test forecast accuracy against the last five years of data

## Data methodology

Divers counted rock lobster on standardized surveys. There are 12 sites, 6 inside a no-take protected area and 6 in fished areas. There are usually 3 surveys per site per year. 

## Statistical methodology 

We'll use an AR1 model to forecast rock lobster abundance. Include a random effect for sites. Fit to all data up until 2018. Years after 2018 are the test set. Forecast these remaining years. Then calculate an error statistic on those years in the test set. 

## Tech context
- We will use the R program
- tidyverse packages for data manipulation
- INLA for bayesian modelling. 

Keep your scripts short and modular to facilitate debugging. Don't complete all of the steps below in one script. Finish scripts where it makes sense and save intermediate datasets. 

When using Rscript from terminal be sure to put the script in "", e.g. `Rscript "Scripts/script1.R"`


## Steps
- Load data from web
- Save as csv, also save a head of the csv for copilot to view
- Fit AR1 INLA model
- Forecasting and error calculation
- Show plot of data, model fits and forecasts

## Progress

Not yet started


## Data 
The datasets are available from the web at the URL below

## Directory structure

Copilot todo

## Data

The main database is here. 

https://raw.githubusercontent.com/cbrown5/R-llm-workshop/refs/heads/main/resources/ATRC-RLS-jasus-edwardsii-maria-island.csv"

Copilot return a head() of this data to yourself, then add meta-data here. 