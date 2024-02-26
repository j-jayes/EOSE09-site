clear all
set more off

cd "/Users/jonathanjayes/Downloads/Lab-1/"


use regional_dataset, clear

**Label regions**
use nutscoord, clear // by request: to label the regions
bysort _ID: egen mean_x = mean(_X)
bysort _ID: egen mean_y = mean(_Y)
keep _ID mean_x mean_y
duplicates drop
merge 1:m _ID using regional_dataset
keep if _merge == 3
* add in a statement to only keep the regions you are interested in
generate SWAU= .

replace SWAU = 1 if country =="Switzerland"
replace SWAU = 1 if country =="Austria"

keep if SWAU == 1


keep _ID mean_x mean_y region
duplicates drop

* save these as labels_regions
save labels_regions, replace



use regional_dataset, clear

generate SWAU= .

replace SWAU = 1 if country =="Switzerland"
replace SWAU = 1 if country =="Austria"

keep if SWAU == 1
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, ///
id(_ID) fcolor(Oranges) ndfcolor(gray) ///
osize(0.02 ..) ocolor(gs8 ..) legend(color(white) pos(7)) legstyle(2) ///
label(data(labels_regions) xcoord(mean_x) ycoord(mean_y) ///
label(region) size(*0.5) length(50) color(grey)) graphregion(color(navy))
