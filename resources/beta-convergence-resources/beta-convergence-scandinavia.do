********************************************************************************
* 					Regional Economics 2024: Additional map help			   *
*					Author: Jonathan Jayes									   *
********************************************************************************

********************************************************************************
* 				         			Set up					   				   *
********************************************************************************


clear all
set more off

cd "/Users/jonathanjayes/Downloads/Lab-1/"


use regional_dataset, clear

********************************************************************************
* 				         Calculating growth rates			   				   *
********************************************************************************


// Step 1: generate log GDP per capita variable
gen log_gdp_pc = log(regional_gdp_cap_1990)
 
// Step 2: calculate the growth in GDP per capita from 1950 onwards
generate scandinavia = .

replace scandinavia = 1 if country == "Sweden"
replace scandinavia = 1 if country == "Denmark"
replace scandinavia = 1 if country == "Norway"

keep if scandinavia == 1

keep if year >= 1900

xtset _ID year

bysort _ID (year): gen growth_regional_gdp_cap_1990 = (regional_gdp_cap_1990[_n]-regional_gdp_cap_1990[_n-1]) / (regional_gdp_cap_1990[_n-1] * (year - year[_n-1]))

bysort _ID: egen mean_growth_rate = mean(growth_regional_gdp_cap_1990)

// Step 3: save the GDP per capita from 1950
keep if year == 1950

********************************************************************************
* 				         Beta-convergence Plot				   				   *
********************************************************************************


// Then draw the graph with two lines through out scatter points.
twoway (scatter mean_growth_rate log_gdp_pc) ///
 (lfit mean_growth_rate log_gdp_pc, legend(label(1 "NUTS2 Regions") label(2 "Linear regression line"))) ///
, title("Beta-convergence plot") subtitle("Sweden 1900 - 2015") ytitle("Average growth rate since 1900") ///
xtitle("Initial GDP per capita (logged)")


