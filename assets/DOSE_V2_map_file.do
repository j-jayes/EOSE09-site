clear all
set more off

cd "/Users/jonathanjayes/Downloads/Lab-1/"


use "DOSE_V2_with_id_from_stata.dta"

* Label variables

label variable country "Full-length country name"
label variable GID_0 "3-digits ISO-Code"
label variable region "Primary region name"
label variable GID_1 "GADM-identifier for level-1 administrative unit, or customly created identifier"
label variable year "Calendar year"
label variable grp_lcu "Gross regional product in local currency and current prices"
label variable pop "Regional population estimate"
label variable grp_pc_lcu "Gross regional product per capita in local currency and current prices"
label variable grp_pc_usd "Gross regional product per capita in US dollar and current prices"
label variable grp_pc_lcu_2015 "Gross regional product per capita in local currency and 2015 prices"
label variable grp_pc_usd_2015 "Gross regional product per capita in US dollar and US 2015 prices"
label variable grp_pc_lcu2015_usd "Gross regional product per capita in local 2015 prices and converted to US dollar using the 2015 exchange rate"
label variable cpi_2015 "Worldbank Consumer Price Index with base year 2015"
label variable deflator_2015 "Worldbank national GDP deflator with base year 2015"
label variable fx "FRED market exchange rate (local currency to one USD)"
label variable PPP "Purchasing Power Parity exchange rate (local currency to one international dollar)"
label variable StructChange "Categorical variable indicating the start of a new data source, changes in administrative boundaries, and when regional time series were extended to a previous version of DOSE"
label variable T_a "Area-weighted annual mean temperature"
label variable P_a "Area-weighted annual total precipitation"

save dose_regional_dataset, replace

* Shape file

clear // clear the dataset in memory

use dose_regional_dataset

* Creating map files
* shp2dta using dose_v2_map_file, database(DOSE_V2_IDs) coordinates(DOSE_V2_coords) genid(_ID) replace


spmap using "DOSE_V2_coords.dta" if year == 2000, id(_ID)

* Map of a variable 

spmap grp_pc_usd_2015 using "DOSE_V2_coords.dta" if year == 2010, id(_ID)

