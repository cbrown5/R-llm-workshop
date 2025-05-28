# Quality R Analysis with Large Language Models

A comprehensive workshop and ebook for using Large Language Models (LLMs) to enhance R programming and data analysis workflows.

## About This Project

This project provides a complete 1-day workshop curriculum for learning how to effectively use language model assistants (ChatGPT, GitHub Copilot, etc.) to write better R code and conduct reliable environmental analyses. The content is designed for R users ranging from intermittent users to experienced professionals.

**Author:** CJ Brown (c.j.brown@utas.edu.au)  
**Institution:** Associate Professor of Fisheries Science, University of Tasmania  
**Live Site:** https://www.seascapemodels.org/R-llm-workshop/

## Citation

If you use this material in your research or teaching:

```
Brown, C.J. (2025). Quality R analysis with large language models. 
Workshop materials. https://www.seascapemodels.org/R-llm-workshop/
```

I am working on an accompanying paper with prompting advice for statistics. Stay tuned for that! 

## Workshop Overview

### What You'll Learn

- **LLM Fundamentals:** How Large Language Models work and their capabilities for R programming
- **Best Practice Prompting:** Advanced techniques that dramatically improve LLM performance for statistical applications
- **GitHub Copilot for R:** Effective use of AI coding assistants in VS Code and RStudio
- **Practical Applications:** Applying LLMs to common environmental analyses (GLMs, multivariate statistics, Bayesian models)
- **Ethics & Copyright:** Responsible use of AI in scientific research
- **Advanced Workflows:** Automated analysis pipelines with agent-based tools

### Workshop Structure (1-day, 7 hours)

| Time | Session | Description |
|------|---------|-------------|
| 9:00-10:00 | Introduction to LLMs for R | How LLMs work, prompt engineering, software overview |
| 10:00-10:30 | LLM Fundamentals (Part 1) | Practical prompting exercises |
| 10:45-11:30 | LLM Fundamentals (Part 2) | Advanced prompting techniques |
| 11:30-12:00 | GitHub Copilot for R | Setting up and using coding assistants |
| 1:00-2:15 | GitHub Copilot (continued) | Hands-on practice with real analyses |
| 2:15-2:45 | Ethics and Copyright | Responsible AI use in research |
| 3:00-3:30 | Advanced Coding Assistants | Agent mode and automated workflows |
| 3:30-4:00 | Conclusion & Discussion | Implications for scientific practice |

## Prerequisites

**Required Knowledge:**
- Basic R proficiency (able to read data, create plots, understand what R does)
- NOT suitable for R beginners

**Software Requirements:**
- R (4.2.2 or later)
- VS Code with R extension (preferred) or RStudio
- GitHub Copilot subscription
- LLM API access (OpenRouter, Anthropic, or OpenAI)

**R Packages:**
```r
install.packages(c("vegan", "ellmer", "tidyverse"))
# INLA for Bayesian computation (see: https://www.r-inla.org/download-install)
```

### Set Up Your Environment
- Install required R packages
- Set up VS Code with R extension
- Configure GitHub Copilot
- Obtain LLM API keys
- See https://www.seascapemodels.org/R-llm-workshop/ for more details

###  Follow the Workshop
- Start with `book/index.md` for software setup
- Work through chapters sequentially
- Practice with provided examples
- Experiment with your own data


## Case Studies & Examples

### Marine Ecology Case Study
The workshop uses real environmental data from the Solomon Islands studying:
- **Bumphead Parrotfish (Topa)** juvenile habitat preferences
- **Benthic Cover Surveys** and coral reef health
- **Logging Impact Assessment** on marine ecosystems
- **Multivariate Analysis** of community composition

### Bayesian Time-Series Example
- **Rock Lobster Abundance** forecasting with INLA
- **Auto-regressive Models** for ecological time-series
- **Cross-validation** and model uncertainty

## Key Learning Outcomes

By completing this workshop, you will:

1. **Understand LLM Capabilities:** Know what LLMs can and cannot do for statistical analysis
2. **Master Prompt Engineering:** Write effective prompts for complex R programming tasks
3. **Use Coding Assistants:** Leverage GitHub Copilot effectively in your R workflow
4. **Apply Best Practices:** Organize projects for optimal AI assistance
5. **Handle Ethics:** Navigate copyright and privacy considerations
6. **Automate Workflows:** Use advanced AI agents for complete analysis pipelines

## Contributing

This is an educational resource. If you find errors or have suggestions:
- Open an issue on GitHub
- Submit a pull request
- Contact the author directly

## License

MIT license - See LICENSE file for details.

## Acknowledgments

- Rick Hamilton (The Nature Conservancy) for providing marine survey data
- ATRC and RLS for reef survey data
- Workshop participants for feedback and improvements
- The R and AI communities for tool development

---

*This workshop material represents cutting-edge practices in AI-assisted data science. As the field evolves rapidly, some specific tools and techniques may change, but the underlying principles of effective human-AI collaboration remain constant.*

## Repo usage and details

### Project Structure

```
R-llm-workshop/
├── README.md                     # This file
├── LICENSE                       # Project license
├── R-llm-workshop.Rproj         # RStudio project file
├── custom.css                    # Custom styling
├── render-slides.R              # Presentation rendering
├── attempt1.R                   # Workshop demo file
│
├── book/                        # Main ebook content
│   ├── index.md                 # Workshop introduction and setup
│   ├── 01-introduction.Rmd     # LLM fundamentals overview
│   ├── 02-llm-prompting-fundamentals.Rmd  # Core prompting techniques
│   ├── 03-github-copilot.Rmd   # GitHub Copilot for R
│   ├── 04-best-practices-setup.Rmd        # Project organization
│   ├── 05-inline-code-editing.Rmd         # Code completion techniques
│   ├── 06-ask-mode.Rmd         # Planning analyses with LLMs
│   ├── 07-edit-mode.Rmd        # Creating code with edit mode
│   ├── 08-agent-mode.Rmd       # Automated workflows
│   ├── 09-ethics-copyright.Rmd # Responsible AI use
│   ├── 10-advanced-llm-agents.Rmd         # Advanced agent tools
│   ├── 11-cost-security.Rmd    # Cost management and security
│   ├── 12-conclusion.Rmd       # Future directions
│   ├── _bookdown.yml           # Bookdown configuration
│   ├── _output.yml             # Output formatting
│   ├── book.bib                # Bibliography
│   ├── packages.bib            # R package citations
│   ├── preamble.tex            # LaTeX preamble
│   ├── style.css               # Book styling
│   └── render-book.R           # Book compilation script
│
├── docs/                       # Generated website (GitHub Pages)
│   ├── index.html              # Main landing page
│   ├── *.html                  # Chapter pages
│   └── libs/                   # Web dependencies
│
├── examples/                   # Practical examples and datasets
│   ├── benthic_wide_format.csv # Sample marine ecology data
│   └── benthic-cover-example/  # Complete analysis example
│       ├── 1_data_input.R     # Data loading
│       ├── benthic-analysis.R # Main analysis
│       ├── benthic-readme.md  # Example documentation
│       └── benthic-report.Rmd # Analysis report
│
├── resources/                  # Supporting materials
│   ├── ATRC-RLS-jasus-edwardsii-maria-island.csv  # Lobster data
│   ├── fish-coral-cover-sites.csv                 # Marine survey data
│   ├── DIY-stats-bot-system.md                    # Custom AI prompts
│   ├── stats-bot-simple.md                        # Basic AI prompts
│   ├── benthic-analysis/                           # Analysis templates
│   └── forecasting-with-inla/                     # Bayesian examples
│
├── LLMs-with-ellmer/          # Advanced R-LLM integration
│   ├── LLMs-with-ellmer.Rmd   # ellmer package tutorial
│   └── tool-use-with-ellmer.Rmd # Creating custom AI tools
│
├── pdf-examples/              # Example documents for AI processing
├── images/                    # Workshop figures and diagrams
└── benthic-cover-example/     # Case study materials
```

### Building the Book

To render the complete ebook locally:

```r
# From the book/ directory
source("render-book.R")
```

This generates the website in the `docs/` folder using bookdown.

