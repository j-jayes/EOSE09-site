* Purpose
* Creating maps from additional data

clear all
set more off

cd "C:/Users/User/Documents/Recon/EOSE09/stata_files/" // set your directory

import delimited "C:\Users\User\Documents\Recon\EOSE09\stata_files\regions_illustrated.csv"

keep if stat_domain == "Agriculture" 

keep if indicator == "Population (persons)" | indicator == "Production of cow milk on farms (1 000 tonnes)"

keep if period == "early"

egen indicator_num = group(indicator), label

reshape wide value, i(ïregion) j(indicator_num)
