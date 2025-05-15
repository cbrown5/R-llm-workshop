# run_all.R
# Script to run the entire benthic cover analysis pipeline

cat("=== Benthic Cover Analysis with Multidimensional Scaling (MDS) ===\n\n")

# Function to run a script and check for errors
run_script <- function(script_name, description) {
  cat(paste0("\n=== Running ", description, " ===\n"))
  result <- try(source(script_name), silent = TRUE)
  
  if (inherits(result, "try-error")) {
    cat(paste0("\nERROR: Failed to run ", script_name, "\n"))
    cat(paste0("Error message: ", attr(result, "condition")$message, "\n"))
    stop(paste0("Execution stopped due to error in ", script_name))
  } else {
    cat(paste0("\n=== Completed ", description, " ===\n"))
  }
}

# Set working directory to the scripts folder
script_dir <- dirname(sys.frame(1)$ofile)
setwd(script_dir)

# 1. Install required packages
run_script("00_install_packages.R", "Package Installation")

# 2. Import data
run_script("01_import_data.R", "Data Import")

# 3. Data wrangling
run_script("02_data_wrangling.R", "Data Wrangling")

# 4. MDS analysis
run_script("03_mds_analysis.R", "MDS Analysis")

# 5. Logging relationship analysis
run_script("04_logging_relationship.R", "Logging Relationship Analysis")

# 6. Generate final report
cat("\n=== Generating Final Report ===\n")
result <- try(rmarkdown::render("05_final_report.Rmd", output_file = "../output/benthic_cover_analysis_report.html"), silent = TRUE)

if (inherits(result, "try-error")) {
  cat("\nERROR: Failed to generate the final report\n")
  cat(paste0("Error message: ", attr(result, "condition")$message, "\n"))
  stop("Execution stopped due to error in report generation")
} else {
  cat("\n=== Final Report Generated Successfully ===\n")
}

cat("\n=== Analysis Complete! ===\n")
cat("The final report is available at: output/benthic_cover_analysis_report.html\n")
