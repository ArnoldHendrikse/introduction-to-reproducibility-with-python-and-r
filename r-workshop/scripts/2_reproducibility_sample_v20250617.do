global 		path "C:\Users\your name\Downloads"

* ---------------------------------------------
* Example 2 - Summary stats of random sample
* ---------------------------------------------

* Step 1: Download the CSV file
local file_url "https://demo.dataverse.nl/api/access/datafile/5470"
tempfile tmpfile
copy "`file_url'" "`tmpfile'"

* Step 2: Import all as string (to handle "NA")
import delimited using "`tmpfile'", clear varnames(1) stringcols(_all)

* Step 3: Clean and convert JOBSATISFACTION
rename jobsatisfaction jobsatisfaction_str
gen double jobsatisfaction = real(cond(jobsatisfaction_str == "NA", "", jobsatisfaction_str))

* Step 4: Drop missing values
drop if missing(jobsatisfaction)

* Step 5: Take a random sample of 20 observations
gen double rand = runiform()
sort rand
keep in 1/20

* Step 6: Generate summary statistics
sum jobsatisfaction, detail

* Step 7: Save summary statistics using postfile
tempname memfile
tempfile csv_out
postfile `memfile' str20 Statistic double Value using "`csv_out'", replace

post `memfile' ("Min.")    (r(min))
post `memfile' ("1st Qu.") (r(p25))
post `memfile' ("Median")  (r(p50))
post `memfile' ("Mean")    (r(mean))
post `memfile' ("3rd Qu.") (r(p75))
post `memfile' ("Max.")    (r(max))

postclose `memfile'

* Load the posted data
use "`csv_out'", clear

* Generate timestamp
local timestamp = c(current_date) + "_" + subinstr(c(current_time), ":", "", .)

* Save to CSV
export delimited using "$path\results\summary_stats_result_`timestamp'.csv", replace

display "✔ Done! Summary statistics saved in results folder."
