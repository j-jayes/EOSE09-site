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
keep if country == "Germany"

keep if year >= 1950

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
, title("Beta-convergence plot") subtitle("Germany 1950 - 2015") ytitle("Average growth rate since 1950") ///
xtitle("Initial GDP per capita (logged)")

 
********************************************************************************
* 				         Beta-convergence Plot with labels	   				   *
********************************************************************************

 
gen region_labels = region if region == "Berlin" | region == "Schleswig-Holstein" | region == "Hamburg"

// Then draw the graph with two lines through out scatter points. Label the points
twoway (scatter mean_growth_rate log_gdp_pc, mlabel(region_labels)) ///
 (lfit mean_growth_rate log_gdp_pc, legend(label(1 "NUTS2 Regions") label(2 "Linear regression line"))) ///
, title("Beta-convergence plot") subtitle("Germany 1950 - 2015") ytitle("Average growth rate since 1950") ///
xtitle("Initial GDP per capita (logged)")




********************************************************************************
* 				         Calculating growth rates (alternative way)			   *
* 				         Compound Annual Growth Rate (CAGR)			 		   *
********************************************************************************

// Read in the data
use regional_dataset, clear


// Step 1: generate log GDP per capita variable
gen log_gdp_pc = log(regional_gdp_cap_1990)
 
// Step 2: calculate the growth in GDP per capita from 1950 onwards
keep if country == "Germany"

keep if year == 1950 | year == 2015

keep region year log_gdp_pc _ID

// Make data wide so that we can 
reshape wide log_gdp_pc, i(_ID) j(year)

generate cagr = (exp(log(log_gdp_pc2015/log_gdp_pc1950)/65)) - 1

// Step 3: scale to percentage for a more sensible y-axis in plot below
replace cagr = cagr * 100


********************************************************************************
* 				         Beta-convergence Plot				   				   *
* 				         Compound Annual Growth Rate (CAGR)			 		   *
********************************************************************************


// Then draw the graph with two lines through out scatter points.
twoway (scatter cagr log_gdp_pc1950) ///
 (lfit cagr log_gdp_pc1950, legend(label(1 "NUTS2 Regions") label(2 "Linear regression line"))) ///
, title("Beta-convergence plot") subtitle("Germany 1950 - 2015") ytitle("Compound average growth rate since 1950") ///
xtitle("Initial GDP per capita (logged)")

 
********************************************************************************
* 				         Beta-convergence Plot with labels	   				   *
* 				         Compound Annual Growth Rate (CAGR)			 		   *
********************************************************************************

 
gen region_labels = region if region == "Berlin" | region == "Schleswig-Holstein" | region == "Hamburg"

// Then draw the graph with two lines through out scatter points. Label the points
twoway (scatter cagr log_gdp_pc1950, mlabel(region_labels)) ///
 (lfit cagr log_gdp_pc1950, legend(label(1 "NUTS2 Regions") label(2 "Linear regression line"))) ///
, title("Beta-convergence plot") subtitle("Germany 1950 - 2015") ytitle("Compound average growth rate since 1950") ///
xtitle("Initial GDP per capita (logged)")

