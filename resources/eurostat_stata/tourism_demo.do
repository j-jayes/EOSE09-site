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
spmap bdrm_ccpncy_rt_n_htls_nd_smlr_st using "eurostat_nutscoord_stata.dta" ///
	if period == "early", id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Bedroom occupancy rate in hotels and similar establishments" ///
	, size(medium)) osize(0.02 ..) ocolor(gs8 ..)
	
	
* map using original coordinates file
spmap bdrm_ccpncy_rt_n_htls_nd_smlr_st using "eurostat_nutscoord_stata.dta" ///
	if period == "late", id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Bedroom occupancy rate in hotels and similar establishments" ///
	, size(medium)) osize(0.02 ..) ocolor(gs8 ..)

