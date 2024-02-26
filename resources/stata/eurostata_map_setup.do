clear 

cd "/Users/jonathanjayes/Documents/PhD/EOSE09-site/resources/stata"

* Here we create a database file and a coordinates file that we link by _ID
shp2dta using NUTS_RG_20M_2021_4326_LEVL_CODE_2, database(eurostat_regions) coordinates(eurostat_nutscoord_stata) genid(_ID) replace

* Now we need to join the data up to the 

use eurostat_data_wide, clear

merge m:1 nuts_code using eurostat_regions

drop if _ID == .

drop if _merge != 3

spmap population_persons using "eurostat_nutscoord_stata.dta" if period == "late", id(_ID)

save eurostat_data_for_mapping, replace
