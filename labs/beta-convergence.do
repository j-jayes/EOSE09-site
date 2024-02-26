clear all
set more off

cd "/Users/jonathanjayes/Downloads/Lab-1/"


use regional_dataset, clear

// Beta convergence
 
// x-axis is log initial GDP, growth rate is on the y-axis.

// Step 1: generate log GDP per capita variable
gen log_gdp_pc = log(regional_gdp_cap_1990)
 
 // Step 2: calculate the growth in GDP per capita from 1950 onwards
keep if country == "Germany"

xtset _ID year

bysort _ID: gen growth_regional_gdp_cap_1990 = (regional_gdp_cap_1990[_n]-regional_gdp_cap_1990[_n-1])/regional_gdp_cap_1990[_n-1]

bysort _ID: egen mean_growth_rate = mean(growth_regional_gdp_cap_1990)


 // Step 3: save the GDP per capita from 1950
keep if year == 1950

// Then draw the graph with two lines through out scatter points.
twoway (scatter mean_growth_rate log_gdp_pc) ///
 (lfit mean_growth_rate log_gdp_pc) ///
, title("Beta Convergence plot") ytitle("Average growth rate since 1950") ///
xtitle("Initial GDP per capita")

 
// Then draw the graph with two lines through out scatter points. Label the points
twoway (scatter mean_growth_rate log_gdp_pc, mlabel(region)) ///
 (lfit mean_growth_rate log_gdp_pc) ///
, title("Beta Convergence plot") ytitle("Average growth rate since 1950") ///
xtitle("Initial GDP per capita")


