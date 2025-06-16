# Example 1

library(broom)
library(writexl)

# Datafile access URL (CSV version)
file_url <- "https://demo.dataverse.nl/api/access/datafile/5470"

# LOAD ---- 
tmp <- tempfile(fileext = ".csv")
download.file(file_url, tmp, mode = "wb")
data <- read.csv(tmp)

# ANALYSIS ---- 
model <- lm(JOBSATISFACTION ~ AVGOVERTIME, data = data)
results <- broom::tidy(model)

# SAVE RESULTS ---- 
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
write_xlsx(results, paste0("../results/regression_result_", timestamp, ".xlsx"))
cat("✔ Done! Regression results saved in results folder.\n")
