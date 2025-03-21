clear all

* Set your working directory and read in the data
cd "/Users/jonathanjayes/Downloads/Lab-1"

use "regional_dataset", clear


* Select country of interest
keep if country == "Sweden"
* Choose time period
keep if year >= 1950
* xtset tells Stata we will do time series operations
xtset _ID year


* For population-weighted sigma convergence
* Step 1: Calculate population weights for each region in each year
bysort year: egen total_pop_year = sum(regional_population)
gen pop_weight = regional_population / total_pop_year

* Step 2: Calculate weighted mean GDP per capita for each year
bysort year: egen w_mean_gdp = sum(regional_gdp_cap_1990 * pop_weight)

* Step 3: Calculate weighted variance and then weighted standard deviation
gen sq_dev = (regional_gdp_cap_1990 - w_mean_gdp)^2
bysort year: egen w_var_gdp = sum(sq_dev * pop_weight)
gen w_sd_gdp = sqrt(w_var_gdp)

* Step 4: Calculate population-weighted coefficient of variation
gen w_cv_gdp = w_sd_gdp / w_mean_gdp

* Step 5: Create the weighted sigma convergence plot
twoway (connected w_cv_gdp year, lcolor(blue) mcolor(blue) msymbol(circle)) ///
       (lfit w_cv_gdp year, lcolor(red)) ///
       , title("Population-weighted Sigma-convergence") subtitle("Sweden 1950 - 2015") ///
       ytitle("Population-weighted CV of GDP per capita") xtitle("Year") ///
       legend(label(1 "Annual weighted CV") label(2 "Linear trend"))

* Step 6: Compare weighted and unweighted measures
* First calculate the unweighted CV as before
bysort year: egen mean_gdp = mean(regional_gdp_cap_1990)
bysort year: egen sd_gdp = sd(regional_gdp_cap_1990)
gen cv_gdp = sd_gdp / mean_gdp

* Then plot both measures for comparison
twoway (connected w_cv_gdp year, lcolor(blue) mcolor(blue) msymbol(circle)) ///
       (connected cv_gdp year, lcolor(red) mcolor(red) msymbol(diamond)) ///
       , title("Sigma-convergence: Weighted vs Unweighted") subtitle("Germany 1950 - 2015") ///
       ytitle("Coefficient of variation") xtitle("Year") ///
       legend(label(1 "Population-weighted CV") label(2 "Unweighted CV"))
