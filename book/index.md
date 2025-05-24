--- 
title: "Quality R analysis with large language models"
author: "CJ Brown (c.j.brown@utas.edu.au)"
date: "`r Sys.Date()`"
site: bookdown::bookdown_site
documentclass: book
bibliography: [book.bib, packages.bib]
url: https://www.seascapemodels.org/R-llm-workshop/
description: |
  1-day workshop for using large language models to generate R code.
link-citations: yes
github-repo: cbrown5/R-llm-workshop
---

# Quality R analysis with large language models

## Summary

If you are using R you are probably using language models (e.g. ChatGPT) to help you write code, but are you using them in the most effective way? Language models have different biases to humans and so make different types of errors. This 1-day workshop will cover how to use language models to learn R and conduct reliable environmental analyses. We will cover:  

- Pros and cons of different tools from the simple interfaces like ChatGPT to advanced tools that can run and test code by themselves and keep going until the analysis is complete (and even written up).  
- Best practice prompting techniques that can dramatically improve model performance for complex statistical applications  
- Applying language models to common environmental applications such as GLMs, multivariate statistics and Bayesian statistics
- Copyright and ethical issues  

We'll finish up with a discussion of what large language models mean for analysis and the scientific process.

Requirements for interactive workshop: Laptop with R, Rstudio and VScode installed. Please see software instructions below. 


#### Who should take this workshop?
The workshop is for: anyone who currently uses R, from intermittent users to 
experienced professionals. The workshop is not suitable for those that need an introduction to R and I'll assume students know at least what R does and are able to do tasks like read in data and create plots.


## About Chris 

I'm an Associate Professor of Fisheries Science at University of Tasmania and an Australian Research Council Future Fellow. I specialise in data analysis and modelling, skills I use to better inform environmental decision makers. R takes me many places and I've worked with marine ecosystems from tuna fisheries to mangrove forests. I'm an experienced teacher of R. I have taught R to 100s people over the years, from the basics to sophisticated modelling and for everyone from undergraduates to my own supervisors.

## Course outline

**Introduction to LLMs for R** 

9-10am
In this presentation I'll cover how LLMs work, best practices prompt engineering, software, applications for R users and ethics. 

**Part 1 LLM fundamentals** 

10-10:30am 

**Tea break: 10:30-10:45**

**Continue Part 1 LLM fundamentals** 


**Ethics and copyright**
11:30-12:00 

**Lunch break: 12:00-1:00pm**

**Part 2 Github copilot for R**

1:00pm-2:45pm

**Tea break 2:45-3:00pm**

**Part 3 Advanced LLM agents** 

3:00-3:30pm

**Conclusion and discussion of what it means for science**

3:30pm-4:00pm

## Software you'll need for this workshop

Save some time for set-up, there is a bit to it. You may also need ITs help if your computer is locked down. 

**R** of course, (4.2.2 or later)

**VScode** 
It takes a bit of time and IT knowledge and setting up to connect VScode to R. So don't leave that to the last minute [See my installation instructions](https://www.seascapemodels.org/rstats/2025/02/07/setting-up-vscode-r-cline.html)

Once you have VScode, make sure you get these extensions (which can be found by clicking the four squares in the left hand menu bar): 

**GitHub Copilot, GitHub Copilot Chat**

If you can't get VScode to work with R you are still welcome to join. Most of the morning session can be done in Rstudio. In the afternoon you'll need VScode if you want to try what I am teaching. 

### Optional software 

**RStudio**. You can do some of this workshop in Rstudio. But you'll get more out of it if you use VScode. 
If you are using Rstudio, make sure you get a Github Copilot account and connect it to Rstudio. 

#### Optional VScode extensions

**Web Search for Copilot** (once installed, follow the instructions to set up your API key, I use Tavily because it has a free tier). 

**Roo code** extension for VScode. 

**Markdown preview enhanced** Let's  you view markdown files in a pane with cmd(cntrl)-shift-V

**Radian terminal** I also recommend installing [radian terminal](https://github.com/randy3k/radian). This makes your terminal for R much cleaner, has autocomplete and seems to help with some common issues. 

## Software licenses

**Github copilot** Go to their page to [sign-up](https://github.com/features/copilot). The free tier is fine. You can also get free Pro access as a student or professor (requires application). 

**API key and account with LLM provider** 

You will need API (application programming interface) access to an LLM to do all the examples in this workshop. This will allow us to interact with LLMs directly via R code. API access is on a pay per token basis. You will need to create an account with one of the below providers and then buy some credits (USD10 should be sufficient). 

Here are some popular choices:

- [OpenRouter](https://openrouter.ai/sign-up) (recommended as gives you flexible access to lots of models)
- [Anthropic](https://console.anthropic.com/login?returnTo=%2F%3F)
- [OpenAI](https://platform.openai.com/api-keys)

Once you have your API key, keep it secret. It's a password. Be careful not to push it to aa github repo accidently. 

## R packages you'll need for this workshop

`install.packages(c("vegan", "ellmer","tidyverse")`

[INLA for Bayesian computation](https://www.r-inla.org/download-install). Use the link, its not on cran. 

## Data 

Not yet complete...

We'll work with some benthic cover data, direct links to csv files are here: 

text files for 2 papers. 
time-series data? 


