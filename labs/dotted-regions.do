********************************************************************************
* 					Regional Economics 2024: Additional map help			   *
*					Author: Jonathan Jayes									   *
********************************************************************************

********************************************************************************
* 				         			Set up					   				   *
********************************************************************************

clear all
set more off

* Set your own directory here
cd "/Users/jonathanjayes/Downloads/Lab-1/"

********************************************************************************
* 				         Dotted lines around a region		   				   *
********************************************************************************

* First we want to keep the coordinates of a region we are interested in
use "nutscoord.dta", clear

* Here 183 is the ID for Sydsverige, we can find this with the browse command
keep if _ID == 183

* Save these coordinates as another file
save nutscoord_sydsverige, replace


* Using the original dataset again
use regional_dataset, clear

* We add a line with the "line" command and customize it somewhat
* We also add a caption to explain it. Sadly it is difficult to make another legend
spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950 ///
	& country == "Sweden", id(_ID) ///
	line(data("nutscoord_sydsverige.dta") size(2) color(red) pattern(shortdash)) ///
	fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per capita in Sweden - 1950", size(medium)) ///
	caption("Red dotted line indicates Sydsverige") ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(5000 (1000) 9000)


********************************************************************************
* 				         Dotted highlighting two regions	   				   *
********************************************************************************

use "nutscoord.dta", clear

* Here we keep two regions
keep if _ID == 161 | _ID == 183

* Save it as another file
save nutscoord_stockholm_sydsverige, replace

* Going back to original dataset
use regional_dataset, clear

spmap regional_gdp_cap_1990 using "nutscoord.dta" if year == 1950 ///
	& country == "Sweden", id(_ID) ///
	line(data("nutscoord_stockholm_sydsverige.dta") size(2) color(green) pattern(shortdash)) ///
	fcolor(Blues2) legend(pos(9)) legstyle(2) ///
	title("Regional GDP per capita in Sweden - 1950", size(medium)) ///
	caption("Green dotted line indicates Stockholm and Sydsverige") ///
	osize(0.02 ..) ocolor(white ..) ///
	clmethod(custom) clbreaks(5000 (1000) 9000)
