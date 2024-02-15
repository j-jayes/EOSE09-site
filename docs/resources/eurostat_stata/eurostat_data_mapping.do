********************************************************************************
* 									Setup									   *
********************************************************************************


clear all

set more off


* set your working directory
cd "/Users/jonathanjayes/Documents/PhD/EOSE09-site/resources/eurostat_stata"

* read in the dataset
use eurostat_data_for_mapping

* read about the indicators here: 
* https://j-jayes.github.io/EOSE09-site/resources/Additional-map-data.html#series

/* 
NB: note that the data comes from the years 2013 - 2021 - I have just selected 
these two years in order to keep the dataset small in size. 

When period == "early", this is the first year, and when period == "late" 
it is the last year.
*/

********************************************************************************
* 									Mapping									   *
********************************************************************************


* set up for drawing a map of scandinavia

gen scandinavia = .
replace scandinavia = 1 if ///
	country == "Sweden" | country == "Norway" | country == "Denmark"

* draw a map of 'Employment rate, Females (% of population aged 20-64)'

spmap emplymnt_rt_fmls_prcnt_f_20_64 using "eurostat_nutscoord_stata.dta" ///
	if period == "late" & scandinavia ==1, id(_ID)


********************************************************************************
* 									Projections								   *
********************************************************************************


* Redo using a recommended projection for Scandinavia
use "eurostat_nutscoord_stata.dta", clear
geo2xy _Y _X, proj(albers) replace
save "eurostat_nutscoord_stata_albers.dta", replace


use eurostat_data_for_mapping, clear


* because we read in the data again, we must gen scandinavia again
gen scandinavia = .
replace scandinavia = 1 if ///
	country == "Sweden" | country == "Norway" | country == "Denmark"


* note that we use the new coordinates file
spmap emplymnt_rt_fmls_prcnt_f_20_64 ///
	using "eurostat_nutscoord_stata_albers.dta" if period == "late" ///
	& scandinavia ==1, id(_ID)



********************************************************************************
* 									Mapping								   *
********************************************************************************


* draw a map of 'Tertiary educational attainment, Females (% of population aged 25-64)'


* let's drop the far flung islands
drop if region == "Canarias"
drop if region == "Guadeloupe"
drop if region == "Martinique"
drop if region == "Mayotte"
drop if region == "La Réunion"
drop if region == "Guyane"
drop if region == "Madiera"
drop if region == "Região Autónoma dos Açores (PT)"


* map using original coordinates file
spmap emplymnt_rt_fmls_prcnt_f_20_64 using "eurostat_nutscoord_stata.dta" ///
	if period == "late", id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Tertiary educational attainment, Females (% of population aged 25-64)" ///
	, size(medium)) osize(0.02 ..) ocolor(gs8 ..)

