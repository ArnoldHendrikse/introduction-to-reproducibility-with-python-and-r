global 		path "C:\Users\your name\Downloads"

* Example 1 - Equivalent of the R script in Stata

* Step 1: Download the CSV file from the URL
local file_url "https://demo.dataverse.nl/api/access/datafile/5470"
tempfile tmpfile
copy "`file_url'" "`tmpfile'"

* Step 2: Load the data
import delimited using "`tmpfile'", clear

describe
list in 1/10
misstable summarize jobsatisfaction avgovertime

* Step 3a: Convert relevant variables to numeric, treating "NA" as missing
* Rename original string variables (if they exist)
rename avgovertime avgovertime_str
rename jobsatisfaction jobsatisfaction_str

* Convert to numeric, treating "NA" as missing
gen double avgovertime = real(cond(avgovertime_str == "NA", "", avgovertime_str))
gen double jobsatisfaction = real(cond(jobsatisfaction_str == "NA", "", jobsatisfaction_str))


* Step 3b: Run the regression
regress jobsatisfaction avgovertime

* Step 4: Save regression results to Excel
* Create timestamp
local timestamp = c(current_date) + "_" + subinstr(c(current_time), ":", "", .)

* Save coefficients using estout (requires `estout` package)
* Install if needed: ssc install estout
* Save regression table as CSV

esttab using "$path\results\regression_result_`timestamp'.csv", replace
display "✔ Done! Regression results saved in results folder."