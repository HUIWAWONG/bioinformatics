# Differential Expression Analysis Pipeline

This pipeline performs differential expression analysis using an R script that leverages the DESeq2 package. It is designed to process input data in RDS format and produce differential expression results as a TSV file.

## Usage

The script can be executed from the command line using the following syntax:

```bash
YOUR_DIRECTORY/Rscript_seurat5 Differential_expression_pipeline.R \
  -i data/input_data.rds \
  -o results/output_DE.tsv \
  --var_effect treatment_group \
  --test_level treated \
  --control_level control \
  --assay_name_in counts \
  --var_adj NULL
```

### Parameters

- `-i` or `--file_in`: Path to the input RDS file containing count data and metadata.
- `-o` or `--file_out`: Path to the output TSV file where results will be saved.
- `--var_effect`: Variable representing the condition or treatment effect.
- `--test_level`: Level of the condition variable to be tested.
- `--control_level`: Reference or control level of the condition variable.
- `--assay_name_in`: Name of the assay containing count data (e.g., `counts`).
- `--var_adj`: Optional variable for adjusting confounding factors (default is `NULL`).

## Examples

### Example 1: Command Line Execution

```bash
YOUR_DIRECTORY/Rscript_seurat5 YOUR_DIRECTORY/Differential_expression_pipeline.R \
  -i YOUR_DIRECTORY/input_data.rds \
  -o YOUR_DIRECTORY/output_DE.tsv \
  --var_effect diag_new \
  --test_level Ph \
  --control_level rest \
  --assay_name_in counts \
  --var_adj library_2
```

### Example 2: SLURM Job Submission

Create a SLURM job script to execute the analysis on a high-performance computing cluster:

```bash
#!/bin/bash
#SBATCH --job-name=DE_analysis           # Job name
#SBATCH --ntasks=1                       # Number of tasks (processes)
#SBATCH --cpus-per-task=1                # Number of CPU cores per task
#SBATCH --mem=8G                         # Total memory per node
#SBATCH --time=24:00:00                  # Time limit hrs:min:sec
#SBATCH --output=DE_analysis_%j.log      # Standard output and error log (%j will be replaced with the job ID)

# Define variables for script and parameters
R_SCRIPT="YOUR_DIRECTORY/Differential_expression_pipeline.R"
INPUT_FILE="YOUR_DIRECTORY/input_data.rds"
OUTPUT_FILE="YOUR_DIRECTORY/output_DE.tsv"
VAR_EFFECT="diag_new"
TEST_LEVEL="Ph"
CONTROL_LEVEL="rest"
ASSAY_NAME="counts"
VAR_ADJ="library_2"

# Execute the R script with the specified parameters
Rscript "$R_SCRIPT" \
  -i "$INPUT_FILE" \
  -o "$OUTPUT_FILE" \
  --var_effect "$VAR_EFFECT" \
  --test_level "$TEST_LEVEL" \
  --control_level "$CONTROL_LEVEL" \
  --assay_name_in "$ASSAY_NAME" \
  --var_adj "$VAR_ADJ"
```

## Output

The results will be saved as a TSV file at the location specified by `-o`. This file contains the differential expression analysis results, including statistical significance and fold changes for each feature.

## Dependencies

- `R` (version >= 4.0)
- R packages:
  - `optparse`
  - `DESeq2`
  - `SummarizedExperiment`
  - `dplyr`

Ensure that all dependencies are installed and available in your R environment before executing the script.

## Notes

- Update the paths to match your environment.
- Adjust resource allocation in the SLURM script based on the size of your dataset.
- Use meaningful variable names for `--var_effect`, `--test_level`, and `--control_level` to ensure reproducibility.

