
cap log close
log using Cesar_RM_Fall22_project, replace

use "D:\1A.SchoolHW\2022 Fall\ECN 140\Emperical project\EPDATA_F2022.dta", clear

//installing package
ssc install estout, replace

//variables generated
gen lnrealsales = log(realsales)
gen sqft2 = sqft^2
gen year2000 = year >= 2000
gen y99 = year >= 1999
gen casesPresent = 0
replace casesPresent = 1 if cases > 0
gen acres2 = acres^2

sort year

// Code for data summary

// get a look at how the data is distributed
histogram realsales, frequency  title("Real House Sale Prices, before Log Transformation") // does appeare to be right skewed
histogram lnrealsales, frequency title("Real House Sale Prices, after Log Transformation") xtitle("Natural Log Value of Inflation-adjusted Sale Prices")

//sactter plot of each variable, indiviually
scatter lnrealsales sqft, title("Log House price vs. Home Square Footage") ytitle("Log of Real Sale Price of Home") mcolor(%25)

scatter lnrealsales acres, title("Log House price vs. Plot Acerage") ytitle("Log of Real Sale Price of Home") mcolor(%25)

scatter lnrealsales age, title("Log House price vs. Age of Home") ytitle("Log of Real Sale Price of Home") mcolor(%25)

scatter lnrealsales condition, title("Log House price vs. Perceived condition of Home") ytitle("Log of Real Sale Price of Home") mcolor(%25)

// get correlation coefficient of two variables
correlate sqft condition

//plot residuals to check for heteroskedasticity
reg lnrealsales year2000##county acres sqft sqft2 age condition
rvfplot, yline(0) title("Residuals vs. Fitted Values from Full Model") mcolor(%25)

//

// Code for Regression Analysis

//full model
reg lnrealsales year2000##county acres acres2 sqft sqft2 age condition, robust

//create table for different models
reg lnrealsales year2000##county
est store m1

reg lnrealsales year2000##county acres acres2 sqft sqft2 age condition
est store m2


reg lnrealsales year2000##county acres acres2 sqft sqft2 age condition, robust
est store m3

esttab m1 m2 m3 using "regTableDiD.rtf", se label ar2 replace ///
	title("Difference in Difference Models for effect of Cases on House Prices") ///
	mtitles("Simple DiD with no Controls" "DiD with Control Variables" "DiD with Robust SEs and Controls") 


log close