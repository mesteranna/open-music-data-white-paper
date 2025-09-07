# Load necessary package
library(stringr)

# Path to your bib folder
bib_folder <- "bib"

# Output file name
output_file <- file.path(bib_folder, "references_all.bib")

# List all .bib files in the folder
bib_files <- list.files(bib_folder, pattern = "\\.bib$", full.names = TRUE)

# Read each .bib file into a character vector
bib_contents <- lapply(bib_files, function(file) {
  readLines(file, warn = FALSE)
})

# Concatenate into a single vector
all_bib <- unlist(bib_contents)

# Optionally, remove empty lines at the end of each file
all_bib <- str_trim(all_bib, side = "right")

# Write to a single .bib file
writeLines(all_bib, con = output_file)

cat("Combined", length(bib_files), "bib files into", output_file, "\n")


# Merge QMD files into two outputs:
# 1. Current working .qmd files to enrich (main folder) -> to_enrich.qmd
# 2. Reusable prior research (reuseqmd folder) -> merged_qmd_review.qmd

# Load library
library(stringr)

# Define folders
qmd_folder_main <- "."          # main folder
qmd_folder_reuse <- "reuseqmd"  # folder with earlier research

# Define output files
target_file <- file.path(qmd_folder_main, "to_enrich.qmd")
reuse_file  <- file.path(qmd_folder_reuse, "merged_qmd_review.qmd")

# Collect .qmd files in main folder (exclude the output itself if it exists)
target_files <- list.files(qmd_folder_main, pattern = "\\.qmd$", full.names = TRUE)
target_files <- target_files[!grepl("to_enrich\\.qmd$", target_files)]

# Collect .qmd files in reuse folder (exclude the output itself if it exists)
reuse_files <- list.files(qmd_folder_reuse, pattern = "\\.qmd$", full.names = TRUE)
reuse_files <- reuse_files[!grepl("merged_qmd_review\\.qmd$", reuse_files)]

# Merge helper function
merge_qmd_files <- function(files) {
  lapply(files, function(file) {
    header <- paste0("\n\n\n# >>> FILE: ", basename(file), " <<<\n\n\n")
    body <- readLines(file, warn = FALSE)
    c(header, body)
  }) |> unlist()
}

# Create merged contents
merged_target <- merge_qmd_files(target_files)
merged_reuse  <- merge_qmd_files(reuse_files)

# Write outputs
writeLines(merged_target, con = target_file)
writeLines(merged_reuse,  con = reuse_file)

cat("Merged", length(target_files), "main QMD files into", target_file, "\n")
cat("Merged", length(reuse_files),  "reuse QMD files into", reuse_file, "\n")
