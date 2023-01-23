********************************************************************************
* 			Regional Economics 2022: Lab 1							   *
* 					Author: Vinzent Ostermeyer								   *
*					Adapted: Jonathan Jayes									   *
********************************************************************************

********************************************************************************
* 			Install additional programs and set-up							   *
********************************************************************************

//to run do-files click the "run-button" or highlight the lines of code and hit ctrl + D (Windows) or shift + cmd + D (Mac)

ssc install spmap, replace
ssc install geo2xy, replace
ssc install shp2dta, replace
ssc install schemepack, replace
ssc install scheme-burd, replace
ssc install colrspace, replace
ssc install palettes, replace
ssc install egenmore, replace
ssc install outreg2, replace

// always comment your code

cd "C:/Users/User/Documents/Recon/EOSE09/stata_files/" // set your directory
help // Stata's help function; cf. also the web or Statalist
version 16.1 // version control

********************************************************************************
* 			Import of Roses-Wolf dataset from Excel into Stata 				   *
********************************************************************************

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A1 Regional GDP") firstrow cellrange(A6:O179) clear // import Excel sheet
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A1 Regional GDP") firstrow cellrange(A6:O179) clear allstring // we import each sheet in the Excel file separately and save it as one file
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
// if there are non-numerical values in a string you cannot use destring and should not use the force-option as it would create missing values
// a better approach is to check all cases that are non-numerical and replace them (e.g. change "one" to "1")
// tab var1 if missing(real(var1))
// replace var1 ... if ...
// destring var1, replace
help reshape // Read up about the command here
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ regional_gdp_millions
save regional_gdp, replace // never overwrite your raw data; e.g., save a copy in a different folder before the analysis

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A1b Regional GDP (2011PPP)") firstrow cellrange(A6:O179) clear allstring // repetition of the steps above for each sheet
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ regional_gdp_2011_ppp_millions
save regional_gdp_2011_ppp, replace

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A3 Population") firstrow cellrange(A6:O179) clear allstring
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ population_thousands
save population, replace

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A4 Employment Share Agriculture") firstrow cellrange(A6:O179) clear allstring
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ employment_share_agriculture
save share_agriculture, replace

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A5 Employment Share Industry") firstrow cellrange(A6:O179) clear allstring
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ employment_share_industry
save share_industry, replace

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A6 Employment Share Services") firstrow cellrange(A6:O179) clear allstring
rename (D E F G H I J K L M N O) (year_1900 year_1910 year_1925 year_1938 year_1950 year_1960 year_1970 year_1980 year_1990 year_2000 year_2010 year_2015)
destring year_*, replace
reshape long year_, i(NUTSCodes Region Countrycurrentborder) j(year)
rename year_ employment_share_services
save share_services, replace

import excel using RosesWolf_RegionalGDP_v6.xlsx, sheet("A2 Area") firstrow cellrange(A6:D179) clear allstring
rename D area_km2
destring area_km2, replace
save area_km2, replace

********************************************************************************
* 			Importing the shapefiles										   *
********************************************************************************

clear // clear the dataset in memory

shp2dta using regions_nuts2, database(regions) coordinates(nutscoord) genid(_ID) replace

use regions, clear // fixing the identifier of the NUTS_Codes so that the merge below works for all regions in the dataset
replace NUTS_CODE = "AT12+AT13" if NUTS_CODE == "AT123"
replace NUTS_CODE = "DE71+DE72" if NUTS_CODE == "DE712"
replace NUTS_CODE = "DE91+DE92" if NUTS_CODE == "DE912"
save regions, replace

use nutscoord, clear // we use the Albers projection; every projection looks a bit different as highlighted e.g. here https://www.statalist.org/forums/forum/general-stata-discussion/general/1306288-legend-in-spmap
scatter _Y _X
scatter _Y _X, msize(tiny) msymbol(point)
help geo2xy // you can try the other projections as well
geo2xy _Y _X, proj(albers) replace
scatter _Y _X, msize(tiny) msymbol(point)
save nutscoord, replace

********************************************************************************
* 			Merge shapefiles and data together   							   *
********************************************************************************

use regional_gdp, clear // we merge all created files together
help merge
merge 1:1 NUTSCodes year using regional_gdp_2011_ppp // this is a 1:1 merge
drop _merge
merge 1:1 NUTSCodes year using population, assert(match) nogen
merge 1:1 NUTSCodes year using share_agriculture, assert(match) nogen
merge 1:1 NUTSCodes year using share_industry, assert(match) nogen
merge 1:1 NUTSCodes year using share_services, assert(match) nogen
merge m:1 NUTSCodes using area_km2, assert(match) nogen // this is a m:1 merge; there is also a 1:m merges; m:m merges are a bad idea
rename NUTSCodes NUTS_CODE
merge m:1 NUTS_CODE using regions
drop if _merge == 2 // we keep all regions that are merged and delete those for which we have geographical information but no data
drop _merge
order _ID, after(NUTS_CODE)

********************************************************************************
* 			Formatting and Creating Variables   							   *
********************************************************************************

rename Countrycurrentborder country
rename (Region regional_gdp_millions regional_gdp_2011_ppp_millions population_thousands area_km2) (region regional_gdp_1990 regional_gdp_2011 regional_population regional_area) // cleaning the dataset

replace regional_gdp_1990 = regional_gdp_1990 * 1000000
replace regional_gdp_2011 = regional_gdp_2011 * 1000000
replace regional_population = regional_population * 1000

bysort country year: egen national_gdp_1990 = total(regional_gdp_1990)
bysort country year: egen national_population = total(regional_population)

gen national_gdp_cap_1990 = national_gdp_1990 / national_population
gen regional_gdp_cap_1990 = regional_gdp_1990 / regional_population
gen regional_gdp_cap_2011 = regional_gdp_2011 / regional_population
sort country region year

gen population_density = regional_population / regional_area // you often have to calculate new variables, which you then can map

egen q_regional_gdp_cap_1990 = xtile(regional_gdp_cap_1990), n(5) by(year) // you can change the number of groups
sort country region year

bysort year: egen mean_gdp_cap_eu = mean(regional_gdp_cap_1990)
sort country region year
gen relative_gdp_cap_eu = regional_gdp_cap_1990 / mean_gdp_cap_eu

bysort year country: egen mean_gdp_cap_country = mean(regional_gdp_cap_1990)
sort country region year
gen relative_gdp_cap_country = regional_gdp_cap_1990 / mean_gdp_cap_country

label variable _ID "Region ID"
label variable year "Year"
label variable country "Country in Current Borders"
label variable regional_gdp_1990 "Regional GDP in 1990 International Dollars"
label variable regional_population "Regional Population"
label variable employment_share_agriculture "Regional Share of Employment in Agriculture"
label variable employment_share_industry "Regional Share of Employment in Industry"
label variable employment_share_services "Regional Share of Employment in Services"
label variable regional_area "Area in KM2"
label variable national_gdp_1990 "National GDP in 1990 International Dollars"
label variable national_gdp_cap_1990 "National GDP per Capita in 1990 International Dollars"
label variable regional_gdp_cap_1990 "Regional GDP per Capita in 1990 International Dollars"
label variable national_population "National Population"

format region NUTS_CODE %20s

save regional_dataset, replace

********************************************************************************
* 						Summary statistics									   *
********************************************************************************

use regional_dataset, clear

tab country
tab region

summarize national_gdp_cap_1990 if year == 1950, detail
summarize regional_gdp_cap_1990 if year == 1950, detail
summarize regional_gdp_cap_1990 if year == 2000, detail

outreg2 using sum_table.doc, replace sum(log) keep(regional_gdp_cap_1990) eqkeep(N mean sd) label // to learn more about outreg2: https://www.princeton.edu/~otorres/Outreg2.pdf
outreg2 if year == 1950 using sum_table_1950.doc, replace sum(log) keep(regional_gdp_cap_1990) eqkeep(N mean sd) label

sort year regional_gdp_cap_1990
br region country regional_gdp_cap_1990 if year == 1900 // compare with table 2.6 in course book
br region country regional_gdp_cap_1990 if year == 2010

********************************************************************************
* 						           Basic Maps    			   				   *
********************************************************************************

// note: try to code everything and use the graph-editor only in exceptional cases

use regional_dataset, clear

help spmap

spmap using "nutscoord.dta" if year == 1950, id(_ID)

spmap using "nutscoord.dta" if year == 1960, id(_ID) ///
	title("My first Map", size(large)) ///
	note("Source: Rosés-Wolf (2020)", size(vsmall) pos(5))
	
spmap national_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID)

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2)

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2)

help format // you can format any variable
format regional_gdp_cap_1990 %12.0fc // 12 numbers left of the decimal point; 0 to the right; commas to denote thousands
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2)

// if there is a /// you have to highlight all lines of that specific task and run them together

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1970, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1970", size(medium)) ///
	osize(0.02 ..) ocolor(gs8 ..)
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950 ", size(medium)) ///
	osize(0.02 ..) ocolor(gs8 ..) ///
	clmethod(custom) clbreaks(0 (1000) 12000)

summarize regional_gdp_cap_1990 if year == 1950, detail

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(1) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 3000 (1000) 6000 12000)
	
spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.2) 0.8) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)
	
spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legstyle(2) ///
	title("Employment Share Industry - 1950", size(large)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.2) 0.8) ///
	legend(pos(9) size(medium) rowgap(1.5) label(5 "60-80 %") label(4 "40-60 %") ///
	label(3 "20-40 %") label(2 "0-20 %") label(1 "No data")) ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..)

graph export share_industry_1950.png, replace width(2000) // save a map as png file to work with it in other programs

spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legstyle(2) ///
	title("1950", size(large)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.1) 0.8) ///
	legend(pos(9) region(fcolor(gs15)) size(2.5)) legtitle("1 = 100%") ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..) ///
	name(share_industry_1950, replace)
	
spmap employment_share_industry using "nutscoord.dta" if year == 2000, id(_ID) fcolor(Blues2) legstyle(2) ///
	title("2000", size(large)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.1) 0.8) ///
	legend(off) ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..) ///
	name(share_industry_2000, replace)
	
graph combine share_industry_1950 share_industry_2000
	
graph combine share_industry_1950 share_industry_2000, graphregion(color(white)) ///
	title(Share Empoyment Industry) ///
	note(Source: Rosés-Wolf (2020), size(small) position(5))

graph combine share_industry_1950 share_industry_2000, graphregion(color(white)) ///
	title(Share Empoyment Industry) ///
	note(Source: Rosés-Wolf (2020), size(small) position(5)) ///
	scheme(s2mono)
	
graph export share_industry_1950_2000.png, replace width(2000)
