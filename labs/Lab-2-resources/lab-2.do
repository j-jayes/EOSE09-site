
********************************************************************************
* 				         Comparing Maps Over Time			   				   *
********************************************************************************

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (2000) 12000)
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 2010, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 2010", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (2000) 12000)

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..)
	
// clmethod(quantile) is actually the default classification method
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(quantile) name(graph_1950, replace)
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 2010, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 2010", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(quantile) name(graph_2010, replace)

graph combine graph_1950 graph_2010
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(quantile) clnumber(5)

spmap q_regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(medium)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (1) 5)
	
spmap relative_gdp_cap_eu using "nutscoord.dta" if year == 1900, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	osize(0.02 ..) ocolor(white ..) title(1900) ///
	clmethod(custom) clbreaks(0 0.8 1 1.2 3) ///
	name(graph_1900, replace)

spmap relative_gdp_cap_eu using "nutscoord.dta" if year == 2010, id(_ID) fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	osize(0.02 ..) ocolor(white ..) title(2010) ///
	clmethod(custom) clbreaks(0 0.8 1 1.2 3) ///
	name(graph_2010, replace)

graph combine graph_1900 graph_2010 // compare with maps 2.4a and 2.4b in the course book

// a discussion about the pros and cons of the different classification methods: https://pro.arcgis.com/en/pro-app/latest/help/mapping/layer-properties/data-classification-methods.htm

********************************************************************************
* 					    Looking at One Country     			   				   *
********************************************************************************

spmap employment_share_industry using "nutscoord.dta" if year == 1950 & country == "Sweden", id(_ID)

spmap employment_share_industry using "nutscoord.dta" if year == 1950 & country == "Sweden", id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

spmap relative_gdp_cap_country using "nutscoord.dta" if year == 1990 & country == "Switzerland", id(_ID) ///
	fcolor(Blues2) legend(pos(5)) legstyle(1) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 0.8 1 1.2 3)

// pay attention to what is included in your dataset especially when calculating relative variables

spmap employment_share_industry using "nutscoord.dta" if year == 1950 & country == "Sweden" | year == 1950 & country == "Denmark", id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

spmap employment_share_industry using "nutscoord.dta" if year == 1950 & (country == "Sweden" | country == "Denmark"), id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

gen group_1 = 0
replace group_1 = 1 if country == "Sweden" | country == "Denmark"

spmap employment_share_industry using "nutscoord.dta" if year == 1950 & group_1 == 1, id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Employment Share Industry - 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

gen group_2 = (country == "Sweden" | country == "Denmark")
assert group_1 == group_2

drop if country != "Sweden" // sometimes it is easier to drop everything but the observations you need
keep if country == "Sweden"
br

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Regional GDP per Capita - 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)
	
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(3.5)) legstyle(2) ///
	title("Regional GDP per Capita", size(8)) ///
	subtitle("Sweden, 1950", size(6)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..)

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) ///
	fcolor(Blues2) legend(pos(5) size(2)) legstyle(2) ///
	title("Regional GDP per Capita", size(6)) ///
	subtitle("Sweden, 1950", size(4)) ///
	osize(0.02 ..) ocolor(white ..) ///
	ndfcolor(gray) ndocolor(none ..) ndsize(0.02 ..) ///
	ysize(8) xsize(7)

********************************************************************************
* 					 Experimenting with Colors    			   				   *
********************************************************************************

use regional_dataset, clear

help spmap // look at fcolor
help colorstyle

spmap national_gdp_cap_1990 using "nutscoord.dta" if year == 1950, id(_ID) fcolor(Heat)

help colorpalette

colorpalette viridis, n(8) nograph
local colors `r(p)'
spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor("`colors'") legstyle(2) ///
	title("1950", size(large)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.1) 0.8) ///
	legend(pos(9) region(fcolor(gs15)) size(2.5)) legtitle("1 = 100%") ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..)

colorpalette viridis, n(8) nograph reverse
local colors `r(p)'
spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor("`colors'") legstyle(2) ///
	title("1950", size(large)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.1) 0.8) ///
	legend(pos(9) region(fcolor(gs15)) size(2.5)) legtitle("1 = 100%") ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..)
	
colorpalette viridis, n(8) nograph reverse
local colors `r(p)'
spmap employment_share_industry using "nutscoord.dta" if year == 1950, id(_ID) fcolor("`colors'") legstyle(2) ///
	title("1950", size(large) color(white)) ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(0 (0.1) 0.8) ///
	legend(pos(9) region(fcolor(navy)) color(white) size(2.5)) legtitle("1 = 100%") ///
	ndfcolor(gray) ndocolor(white ..) ndsize(0.02 ..) graphregion(color(navy))

********************************************************************************
* 					    Looping, Globals and Locals   				           *
********************************************************************************

foreach var of varlist employment_share_industry employment_share_services {
	foreach i of numlist 1950 (10) 1970 {
		spmap `var' using "nutscoord.dta" if year == `i', id(_ID)
	}
}
	
global varlist employment_share_industry employment_share_services
foreach var of varlist $varlist {
	foreach i of numlist 1950 (10) 1970 {
		spmap `var' using "nutscoord.dta" if year == `i', id(_ID) name(`var'_`i', replace)
	}
}
graph combine employment_share_industry_1950 employment_share_industry_1960 employment_share_industry_1970 

macro drop _all // clears globals; useful because they remain active in the background, which could interfer with other active Stata sessions

local a "Hello"
local b "World"
di "`a' `b'"

local x = 1
local y = 2
di `x' + `y'

********************************************************************************
* 				       			Graphs						   				   *
********************************************************************************

twoway line employment_share_agriculture year if region == "Sydsverige"

replace region = "Southern Sweden" if region == "Sydsverige"

twoway line employment_share_agriculture year if region == "Southern Sweden"

twoway line employment_share_agriculture year if country == "Sweden", by(region)

twoway line employment_share_industry employment_share_services year if country == "Sweden", by(region)

replace employment_share_industry = employment_share_industry * 100
replace employment_share_services = employment_share_services * 100

twoway line employment_share_industry employment_share_services year if country == "Sweden", ///
	by(region) xlabel(1900 (50) 2000)

twoway line employment_share_industry employment_share_services year if country == "Sweden", ///
	by(region, note("")) subtitle(, lstyle(none) size(small)) ///
	xlabel(1900 (50) 2000) ylabel(0 (40) 80)

twoway line employment_share_industry employment_share_services year if country == "Sweden", ///
	by(region, note("")) subtitle(, lstyle(none) size(small)) ///
	xlabel(1900 (50) 2000) ylabel(0 (40) 80) ytitle(Share in %) ///
	legen(size(vsmall))
	
twoway line employment_share_industry employment_share_services year if country == "Sweden", ///
	by(region, note("")) subtitle(, lstyle(none) size(small)) ///
	xlabel(1900 (50) 2000) ylabel(0 (40) 80) ytitle(Share in %) ///
	legend(size(vsmall)) scheme(burd)

twoway line employment_share_industry employment_share_services year if country == "Sweden", ///
	by(region, note("")) subtitle(, lstyle(none) size(small)) ///
	xlabel(1900 (50) 2000) ylabel(0 (40) 80) ytitle(Share in %) ///
	legend(size(vsmall)) scheme(swift_red)

help scheme
help schemepack

********************************************************************************
* 						      By Request: Labelling		    				   *
********************************************************************************

use nutscoord, clear // by request: to label the regions
bysort _ID: egen mean_x = mean(_X)
bysort _ID: egen mean_y = mean(_Y)
keep _ID mean_x mean_y
duplicates drop
merge 1:m _ID using regional_dataset
keep if _merge == 3
keep if country == "France"
keep _ID mean_x mean_y region
duplicates drop
save labels_regions, replace
use regional_dataset, clear
keep if country == "France"
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950, ///
	id(_ID) fcolor(Oranges) ndfcolor(gray) ///
	osize(0.02 ..) ocolor(gs8 ..) legend(color(white) pos(7)) legstyle(2) ///
	label(data(labels_regions) xcoord(mean_x) ycoord(mean_y) ///
	label(region) size(*0.5) length(50) color(grey)) graphregion(color(navy))
	// to have multiple lines of labels see https://www.statalist.org/forums/forum/general-stata-discussion/general/1395567-how-to-add-state-names-and-labels-using-spmap

********************************************************************************
* 						      Extra Material    		    				   *
********************************************************************************

bysort country year: egen test_1 = total(regional_gdp_1990) // pay attention to the sorting when calculating totals
bysort country (year): egen test_2 = total(regional_gdp_1990)
br country region year regional_gdp_1990 national_gdp_1990 test_1 test_2
assert test_1 != test_2 // useful to test whether a condition holds (or not)
assert test_1 == national_gdp_1990

replace employment_share_agriculture = employment_share_agriculture * 100
bysort country region (year): gen change_share_agriculture_1 = employment_share_agriculture[_n] - employment_share_agriculture[_n-1] // cf. also the time operators l., f. and d. as well as xtset and tsset

// https://datacatalog.worldbank.org/search/dataset/0038272 : link to world maps; can be converted into Stata format; use e.g. "World Country Polygons - Very High Definition"; already contains some data
// https://data.worldbank.org/ : other World Bank data; can e.g. be matched to the maps
// read these articles on how to make good maps and discuss https://www.bloomberg.com/news/articles/2015-06-25/how-to-avoid-being-fooled-by-bad-maps https://mgimond.github.io/Spatial/good-map-making-tips.html
