# Example 2

library(broom)
library(writexl)

# Datafile access URL (CSV version)
file_url <- "https://demo.dataverse.nl/api/access/datafile/5470"

# LOAD ---- 
tmp <- tempfile(fileext = ".csv")
download.file(file_url, tmp, mode = "wb")
data <- read.csv(tmp)

# ANALYSIS ---- 
sample <- sample(data$JOBSATISFACTION, size = 20, replace = FALSE)
summary_sample <- summary(sample)
table <- data.frame(
  Statistic = names(summary_sample),
  Value     = as.numeric(summary_sample)
)

# SAVE RESULTS ---- 
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
write_xlsx(table, paste0("../results/summary_stats_result_", timestamp, ".xlsx"))
cat("✔ Done! Regression results saved in results folder.\n")

