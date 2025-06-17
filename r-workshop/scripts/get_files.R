# install.packages(c("httr","jsonlite","writexl"))  # if needed

library(httr)
library(jsonlite)
library(writexl)

# ── CONFIG ──
api_token     <- readLines("token.txt", warn = FALSE)   # or hard-code your token
dataverse_url <- "https://demo.dataverse.nl"
dataset_doi   <- "doi:10.80227/PDVNL/6CGUOY"
output_file   <- "file_list.xlsx"

# ── 1. FETCH DATASET INFO ──
resp <- GET(
  url = paste0(dataverse_url, "/api/datasets/:persistentId"),
  query = list(persistentId = dataset_doi),
  add_headers(`X-Dataverse-key` = api_token)
)
stop_for_status(resp)

info     <- fromJSON(content(resp, "text", encoding = "UTF-8"))$data
files    <- info$latestVersion$files          # list of file objects

# https://demo.dataverse.nl/api/access/datafile/[file_ID]

# ── 3. OUTPUT ──
print(files)
write_xlsx(files, output_file)
cat("✔ Wrote files to", output_file, "\n")