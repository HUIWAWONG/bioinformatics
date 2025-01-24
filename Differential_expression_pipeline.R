options(future.globals.maxSize = 10 * 1024 * 1024^2) # Set maximum size for global variables to 10GB

# Load necessary libraries
suppressPackageStartupMessages({
  library(optparse)               # For parsing command-line options
  library(DESeq2)                 # For differential expression analysis
  library(SummarizedExperiment)   # For handling genomic data structures
  library(dplyr)                  # For data manipulation
})

# Source the required script for additional functions
source('YOUR_DIRECTORY/Function_DE_script.R')

# Define command-line options
option_list <- list(
  optparse::make_option(c("-i", "--file_in"), type = "character", help = "Input RDS file containing count data and metadata.", metavar = "character"),
  optparse::make_option(c("-o", "--file_out"), type = "character", help = "Output file to save the results.", metavar = "character"),
  optparse::make_option(c("--var_effect"), type = "character", default = "NULL", help = "Condition or treatment effect variable."),
  optparse::make_option(c("--test_level"), type = "character", default = "test", help = "Level of the condition variable to be tested."),
  optparse::make_option(c("--control_level"), type = "character", default = "control", help = "Reference/control level of the condition variable."),
  optparse::make_option(c("--assay_name_in"), type = "character", default = "counts", help = "Name of the assay containing count data."),
  optparse::make_option(c("--var_adj"), type = "character", default = "NULL", help = "Optional variable for adjusting confounding factors.")
)

# Parse command-line arguments
parser <- optparse::OptionParser(option_list = option_list)
args <- optparse::parse_args(parser)
print(args)

# Validate required arguments
required_args <- c("file_in", "file_out", "var_effect", "test_level", "control_level")
missing_args <- required_args[sapply(required_args, function(arg) is.null(args[[arg]]))]
if (length(missing_args) > 0) {
  stop(paste("Error: Missing required arguments:", paste(missing_args, collapse = ", ")))
}

# Differential expression analysis
tryCatch({
  # Load the input object
  obj_in <- readRDS(args$file_in)
  
  # Run differential expression analysis
  res_DE <- run_DE_DESeq2(
    obj_in = obj_in,
    var_effect = args$var_effect,
    test_level = args$test_level,
    control_level = args$control_level,
    assay_name_in = args$assay_name_in,
    var_adj = args$var_adj
  )
  
  # Save the results to a TSV file
  write.table(res_DE, file = args$file_out, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
  message("Differential expression analysis completed successfully.")
}, error = function(e) {
  stop(paste("Error during differential expression analysis:", e$message))
})
