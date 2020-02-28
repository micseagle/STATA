/* Chapter 5 
This file contains the codes for some descriptive analysis. 
It makes use of the indicators that were calculated in chapter 4 do files. 
*/


*Chapter 5
**************** TABULATIONs********
/* The last step for most indicators, included some tabulations based on various
socio-economic variables.  
This tabulaion can be created for any indicator, using the appropriate weight. In this example,
Early Childhood Development Indicator is first tabulated for each region with child weights,
and then without weights. 

The third table below gives the tabulation of ECDI, by region and gender. */ 
/*1. Input the address of the directory where the relevant dataset is stored*/ 
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\Iraq"
/*2. Use the file where ECDI or the indicator you want to use was calculated. If not saved,
please rerun the code to calculate ECDI and then use the commands
in step 3 to step 6
ECDI is calculated in do file 'Chapter4_ Development_and_Skills line 3-100*/
use Iraq_ch_ready,clear
/*3. Here we disaggregate the ECDI result by region (HH7) using the relevant weights (chweight)*/ 
table HH7 [pw= chweight],c (mean develop)
/*4. Disaggregating ECDI by region but without weights  */
table HH7,c (mean develop)
/*5. Disaggregating the ECDI by region, age and gender */
table HH7 HL4 UB2 [pw= chweight],c (mean develop)
/*Based on this it is clear the the general syntax for tabulation is
table "variable of interest" [pw="relevant weight"], c (mean "education indicator of interest")   

For cross tabulation it is:
table "first variable of interest" "second variable of interest" "n variable of interest" [pw="relevant weight"], c (mean "education indicator of interest") */

****************Sub-national disaggregation***********
/*For this example, ANAR has been used as the "education indicator of interest"   */
/*1.Input the directory address if beginning a new file. 
If directory address has been inputed before, proceed to step two */
/*2. Calculate ANAR following the steps for ANAR calculation
Code for ANAR can be found in Chapter4_Participation_and_Completion, line 4-56  */ 
/*3. For regional disaggregation,'HH7' is the relevant variable.
Since ANAR is by level of education, include 'age_school'*/
table age_school HH7 [aw=hhweight], c (mean attendance)


****************Education status analysis by age cohort****************
**Chart per age where children are (level of education or out of school = 100%)
*1 Use SL_ready
use SL_ready,clear
*2. Generate a new variable for OOS and age 
gen oos=0 
replace oos=1 if ED9==2|ED4==2
replace oos=1 if (age_school==2|age_school==3)&ED10A==0 /*attending pre-primary but older*/
/*the line below takes out exceptions like people who already graduated from 
the education level they should by their age*/
replace oos=0 if age_school==1 & (ED5A==1 & ED5B==15 & ED6==1 & ED9==2)
replace oos=0 if age_school==2 & (ED5A==2 & ED5B==24 & ED6==1 & ED9==2)
replace oos=0 if age_school==3 & (ED5A==3 & ED5B==33 & ED6==1 & ED9==2) 

*3. Generate a new variable based on enrolment in different level of education 
gen where=ED10A+1
replace where=0 if oos==1
replace where=4 if ED10A==4|ED10A==5
replace where=. if ED10A==8|ED10A==9
*4. Only keeping children under 18
keep if schage<=18
*5. Get total number of children by age and level of eduucation
table schage where, c (sum hhweight) replace
*6. using filling command to get missing observations as 0 and present observation as 1
fillin schage where
*7. Replacing . values with 0
replace ta=0 if tab==.
drop _f
/*8. Reshaping the table so that each row represents one shool age and the different levels children of that
school age are attending*/
reshape wide  table1, i(scha) j (where)   
*9.Generating a table to calculate total so as to be able to calculate percentages
gen table_tot=table10+table11+table12+table13+table14
*10. Calculating percentages
foreach var of var table10 table11 table12 table13 table14 {
replace `var'=100*`var'/table_tot
replace `var'=. if `var'<0.5
}
drop table_tot
*10. Copy-paste the table from the data explorer or use the export command to move it to excel
export excel table10 table11 table12 table13 table14 using  "NAME.xslx", sheet("Sheet_name") sheetmodify cell(B2) nolabel




***************Pathwway Analysis**********************

**PATHWAY ANALYSIS
/*1. Input the address where the data is stored  */
/*cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"*/
*2. Use the merged dataset file called "Country_READY"
use SL_ready,clear
/*3. Keeping only observations at the official upper secondary age
for SL, this is 15 to 18 year olds. Please adjust this according to
the national policy of your country*/
keep if schage>=15&schage<=18
/*4. Generate variable for each category for pathway analysis.
These are:
	i. trans_up: 1 if individual transitioned to upper secondary
				0 otherwise
	ii.not_trans_up: 1 if individual completed lower secondary but
						did not transition to upper secondary
					 0 otherwise
	iii.att_low_sec: 1 if individual is still attending lower secondary
					0 otherwise
	iv. drop_low_sec: 1 if individual dropped out of lower secondary
					0 otherwise
	v. not_trans_low: 1 if individual completed primary education
						but did not transition to lower secondary
					  0 otherwise
	vi. att_pri: 1 if individual is still attending primary
				 0 otherwise
	vii. drop_pri: 1 if individual dropped out of primary
			       0 otherwise
	viii. never: 1 if individual never entered primary
				 0 otherwise
*/
foreach var in trans_up not_trans_up att_low_sec drop_low_sec /*
*/not_trans_low att_pri drop_pri never {
gen `var'=0
}
/*4. Replace value to 1 if individual transitioned to upper secondary
using ED5A (Highest level of education attended)  is greater than the 
value assigned to upper secondary. "tab ED5A" and "tab ED5A, nol" 
to check this */
replace trans_up=1 if ED5A==3|ED5A==4|ED5A==5
/*5. Replace value to 1 if individual completed lower secondary but did 
not transition to upper secondary using:
ED9==2 indicates the individual did not attend school in the current year
ED5A==2 indicates the highest level attained is lower secondary
ED5B==3 indicates highets grade attended in that level
ED6==1 indicates indvidual completed the highest grade identified in ED5A */
replace not_trans_up=1 if ED9==2&ED5A==2&ED5B==3&ED6==1
/*6. Replace value to 1 if individual is still attending lower secondary
ED9==1 indicates the individual attended school in the current year
ED10A==2 indicates the level of education attended in current year is lower secondary
*/
replace att_low_sec=1 if ED9==1&ED10A==2
/*7. Replace value to 1 if individual dropped out of lower secondary
ED9==1 indicates the individual attended school in the current year
ED5A==2 indicates the highest level of education attained was lower secondary*/
replace drop_low_sec=1 if ED9==2&ED5A==2
/*8. Replace value to 1 if individual did not transition to lower secondary
ED9==2 indicates the individual did not attend school in the current year
ED5A==1 indicates the highest level of education attained was primary*/
replace not_trans_low=1 if ED9==2&ED5A==1
/*9. Replace value to 1 if individual is still attending primary
ED9==1 indicates the individual attended school in the current year
ED10A==1 indicates the individual attended primary level in the current year  */
replace att_pri=1 if ED9==1&ED10A==1
/*10. Replace value to 1 if individual dropped out of primary
ED9==2 indicates the individual attended school in the current year
ED5A==1 indicates that the highest level of education attained is primary*/
replace drop_pri=1 if ED9==2&ED5A==1
/* 11.Replace value to 1 if individual never entered primary
ED4==2 indicates individual never attended school or ECE programmes
ED5A==0 indicates highest level of education attained is ECE
ED10A==0 indicates level of education attended in current year is ECE */
replace never=1 if ED4==2|ED5A==0|ED10A==0



/*12. Calculate the mean of each variable generated above  */
foreach var in trans_up not_trans_up att_low_sec drop_low_sec /*
*/not_trans_low att_pri drop_pri never {
table total [pw=hhweight], c (mean `var')
}

/*13. Since pathway analysis, covers 12 categories but we only calculate 5.
The remaining categories can be calculated as:
/* Missing categories:
1.	Ever entered primary: 100-never entered primary
2.	Never entered primary: calculated
3.	Completed primary: 100-still attending primary-dropped out of primary
4.	Still attending primary: calculated
5.	Dropped out of primary: calculated
6.	Transitioned to lower secondary= 100-did not transition to lower secondary
7.	Did not transit to lower secondary: calculated
8.	Completed lower secondary: calculated
9.	Still attending lower secondary: calculated
10.	Dropped out of lower secondary: calculated
11.	Transitioned to upper secondary: calculated
12.	Did not transit to upper secondary= 100- transition to upper secondary
to do get theese values, we generate a new variable sum
to summarise the share in each of the variables as 0 and 1 */ */ 
gen sum=0

/*14. Replace the value of the new var as a sum of its original value and each variable.
The minimum value sum can have is 0 and the maximum is 2.*/
foreach var in trans_up not_trans_up att_low_sec drop_low_sec /*
*/not_trans_low att_pri drop_pri never {
replace sum=sum+`var'
}
/*15.Tabulate for sum==2, transfer these to excel and calculate the remaining indicators */
foreach var in trans_up not_trans_up att_low_sec drop_low_sec /*
*/not_trans_low att_pri drop_pri never {
tab `var' if sum==2
}





***********************************Logit Model: Marginal Effects
/*1. Input the address where the data is stored  */
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country_data\MICS6\Laos"
/*2. Use the country data, we prepared in the data preparation and where relevant
indiicators are calculated
For this exerecise, please ensure that ANAR is calculated 
Code for ANAR can be found in Chapter4_Participation_and_Completion, line 4-56*/
use laos_ready,clear
/*3.Preparing the data for marginal effects. 
 no variable should have don't know values or missing values. Drop 
them from all independent variables
Marginal effects is a way of presenting result as differences in probabilities
Therefore, it is important to specify the base category.
 Here, we recode richest wealth as 0 to be the base category.
 Therefore all regression will be compared to the richest 
 We also invert mother's level of education
 to have the highest educated mother as the base */
replace windex5=0 if windex5==5
drop if melevel==7|melevel==9
replace melevel=10-melevel 
/*4.Since the analysis is for childen in lower secondary level
only keep those obbservation which fall in the relevant age group  */
keep if age_school==2&ethnic!=9
/* 5. use the logit command to run a logit on ethnicity.
The "i." before ethnicity tells stata that ethnicity is a categorical variable
and asks stata to analyse it as a series of dummy variable
Using no log shortens the output and does not show the iteration log*/
logit attendance i.ethnicity
logit attendance schage schage2 i.ethnicity, nolog 
logit attendance schage schage2 i.HL4 i.HH6 i.hh7r i.ethnicity i.melevel, nolog 
logit attendance schage schage2 i.HL4 i.HH6 i.windex5  i.hh7r i.ethnicity i.melevel, nolog 
margins HH6 windex5 hh7r ethnicity
/* Note stata uses the most latest regression to run the margins for, above different models are provided
 */

*Logit model
/*2. Use the country data, we prepared in the data preparation and where relevant
indiicators are calculated
For this exerecises, please ensure that ANAR is calculated
Code for ANAR can be found in Chapter4_Participation_and_Completion, line 4-56 */
use laos_ready,clear
/*Only keep relevant observations, based on age. Here, we are predicting
the lower secondary attendance for different groups*/
keep if age_school==2&ethnic!=9
/* Use logit to run a logistic regression and then us predict the values based on the model
The "i." before ethnicity tells stata that ethnicity is a categorical variable
and asks stata to analyse it as a series of dummy variable
Using no log shortens the output and does not show the iteration log */
logit attendance schage schage2 HL4 i.HH6 i.windex5  i.hh7r i.ethnicity, or nolog 




*******************************Multinomial
/*1. Input the address where the data is stored  */
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country_data\MICS6\Laos"
/*2. Use the country_READY dataset*/
use laos_ready,clear
/*3. Only keep those observations who reported to have attended last grade 
of lower secondary in "previous" year */
keep if ED16B==24 
/*4. We are going to estimate the probability of a student transitioning, repeating or dropping out
 which are essentially the three possibilities they are confronted to after a certain grade.*/
gen prog=.
/*5. Possibility 1: succesful transition.
 Recode to 1 if individual passed the last grade and is  attending a grade higher
than lower secondary in the current year  */
replace prog=1 if ED10A==3|ED10A==4 
/*6. Possibility 2: Repeated i.e still attending last grade in the current year
Recode to 2 if individual reported to be in the same grade in the current year  */
replace prog=2 if ED10B==24 
/*7. Possibility 3: Dropped out i.e. not in school
Recode to 3 if individual has dropped out of school in the current year*/
replace prog=3 if ED9==2
mlogit prog i.HL4 i.HH6 i.windex5  i.hh7r 
margins windex5
/*When interpreting, the results will be show by possibilities according 
to the independent variables.*/



**************HEATMAP
/*1. Input the address where the data is stored  */
/* cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country_data\MICS6\Laos"*/
/*2. Use the country_READY dataset*/
use laos_ready,clear
/*3. Recode the variables to create base category. 
Here, the richest quintile is recoded
missing values from melevel is dropped
and melevel is reversed   */
replace windex5=0 if windex5==5
drop if melevel==7|melevel==9
replace melevel=10-melevel 
/*4. Keeping only those observations which fall in
the primary school range and known ethnicity   */
keep if age_school==1&ethnic!=9
/*5.Run a logit on primary attendance based on socioeconomic variables  */
logit attendance schage schage2 i.HL4 i.HH6 i.windex5  i.HH7 i.ethnicity i.melevel, nolog 
/*6. Now, we get the average marginal effects for all covariates using dydx(*)
and atmeans specifies that covariates be fixed at their means */
margins, dydx(*) atmeans
mat R1=r(PT)
/*7.Repeat steps 2 to 6 for lower secondary and upper secondary in lines 293-309 */
use laos_ready,clear
replace windex5=0 if windex5==5
drop if melevel==7|melevel==9
replace melevel=10-melevel 
keep if age_school==2&ethnic!=9
logit attendance schage schage2 i.HL4 i.HH6 i.windex5  i.HH7 i.ethnicity i.melevel, nolog 
margins, dydx(*) atmeans
mat R2=r(PT)
use laos_ready,clear
replace windex5=0 if windex5==5
drop if melevel==7|melevel==9
replace melevel=10-melevel 
keep if age_school==3&ethnic!=9
logit attendance schage schage2 i.HL4 i.HH6 i.windex5  i.HH7 i.ethnicity i.melevel, nolog 
margins, dydx(*) atmeans
mat R3=r(PT)
clear
/*8.Save the three matrices as new coloumns
and copy and paste the new table into excel*/
svmat R1
svmat R2
svmat R3
drop if R11==.b|R21==.b
replace R11=. if R14>0.05
replace R21=. if R24>0.05
replace R31=. if R34>0.05
keep R*1
/*Note: the first two rows show the ME for scahge and schage2
We can ignore these and st.
Select the cells and use conditional formatting
to create the heatmap  */
