
# Load necessary library
library(rmarkdown)

# Define the path to the .md file
md_file <- "genAI-overview.Rmd"
# md_file <- "LLMs-with-ellmer/tool-use-with-ellmer.Rmd"

# Render the .md file as io slides
render(md_file, output_format = "ioslides_presentation")
# render(md_file, output_format = "md_document")

ggplot(data = mtcars, aes(x = wt, y = mpg)) +
  geom_point() +
  theme_minimal()