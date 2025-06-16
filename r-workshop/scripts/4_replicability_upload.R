library(httr)
library(broom)
library(writexl)

# ── CONFIGURATION ──
# Instructions to get the Dataverse API token here: https://scribehow.com/shared/How_to_Create_an_API_Token_for_DataverseNL__B_tfY8QVTIOwl2kozwpfWg
api_token     <- readLines("token.txt", warn = FALSE)
dataverse_url <- "https://demo.dataverse.nl"
dataset_doi   <- "doi:10.80227/PDVNL/6CGUOY"

# ── LOAD DATA ──
file_url <- "https://demo.dataverse.nl/api/access/datafile/5470"
tmp_csv  <- tempfile(fileext = ".csv")
download.file(file_url, tmp_csv, mode = "wb")
data <- read.csv(tmp_csv)

# ── ANALYSIS ──
model   <- lm(JOBSATISFACTION ~ AVGOVERTIME, data = data)
results <- tidy(model)

# ── SAVE TO TEMPORARY XLSX ──
timestamp <- format(Sys.time(), "%Y%m%d_%H%M%S")
tmp_xlsx  <- tempfile(pattern = paste0("regression_", timestamp), fileext = ".xlsx")
write_xlsx(results, tmp_xlsx)

# ── UPLOAD TO DATAVERSE ──
upload_url <- sprintf(
  "%s/api/datasets/:persistentId/add?persistentId=%s",
  dataverse_url,
  URLencode(dataset_doi, reserved = TRUE)
)

resp <- POST(
  url    = upload_url,
  add_headers(`X-Dataverse-key` = api_token),
  body   = list(file = upload_file(tmp_xlsx)),
  encode = "multipart"
)
