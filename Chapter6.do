**********************************************Example 1: CHILD LABOUR
/*Please ensure to calculate child labour indicator
before using it
It can be found under the cross-sectoral indicators.
Make sure to run the indicator line 82-146 from the file Chapter 4_Cross-sectoral indicators and then run
the following commands Here we will not need the cd and use command
as it is assumed that you will be using the relevant file.
Child labour indicator is calculated
us the country_fs_ready file.
We are using SL_fs_ready*/


******ANALSIS 1: DESCREPTIVE STATISTICS FOR CHILD LABOUR
*1. Generate a new variable to group children's ages based on official age for each edu level
gen age=.
replace age=1 if CB3>=5&CB3<=11
replace age=2 if CB3>=12&CB3<=14
replace age=3 if CB3>=15&CB3<=17
*2. Cross-tabulate based on socio-economic variables for each of the child-labour variables
foreach var of var total HL HH6 HH7 age att melevel windex5 {
table `var'  [pw=fsweight], c (mean childlatotal mean childlahh mean childlaec mean hazard) 
}

******ANALYSIS 2: EXPECTED ATTENDANCE AND CHILD LABOUR
/*Expected attendance of children by age and working status */

*1. Generate age-squared variable to add in the regression model
gen age2=CB3*CB3
/*2. Run a logit on attendance, the interaction term of child labour and age, 
 and include other relevant socio-economic variables*/
logit attendance i.childlatotal#CB3 i.HL4 i.HH6 i.windex5  i.HH7 i.melevel, or nolog 
*3. Get the expected attendance based on the interaction term
margins childlato#CB3


*********************************************Example 2: CHILD MARRIAGE
/*Please make sure to run the child marriage code to calculate
the share of child marriage, particlarly the "early15" variable.
Child marriage code can be found in 'Chapter4_Cross-sectoral indicator, line 179-208
This variable will be used in the regression below.
The child marriage indicator is a cross-sectoral indicator
using the Country_ready file*/

*******ANALYSIS 1: DESCRIPTIVE ANALYSIS CHILD MARRIAGE 
/*1.The command below will give the cross tabulation
by gender*/
foreach var of var total  HH6 ED5A windex5 {
table `var' HL4 [pw=hhweight], c (mean early15 mean early18)
}

/*******ANALYSIS 2: REGRESSION ON CHILD MARRIAGE :Expected share of women 
getting married before 15 by education and wealth quintile */

/*1.To run the regression, we make sure our variables are ready
TO avoid loss of observations, we include all
those who reported to have never attended ECE or school to 
be equivalent to ED5A. i.e their highest level of education
is ECE.
We do so to not lose the depth of the data*/
replace ED5A=0 if ED4==2
/*2. Replace missing and don;t know values  */
replace ED5A=. if ED5A==9|ED5A==8
/*3. Keeping only female observations */
keep if HL4==2
/*4. Run a logit model on early marriage based on relevant socio-economic
variables. Here area, wealth and education have been used */
logit early15  i.HH6 i.windex5  i.HH7 i.ED5A, or nolog 
/*5. Based on the model derive the predicted probability/ expected value 
of early marriage based on education level and wealth  */
margins ED5A windex5

***************************Example 3: CHILDREN WITH DISABILITIES


*********ANALYSIS 1: PREVALENCE OF EACH DISABILITY
/*Please make sure to run the child disability indicator.
The indicator uses the country_fs_ready dayaset.
*Calculate child functioning from Chapter4Cross sectoral indicators file, line 211-259


In the indicator calculation, some cross-tabulations are listed.*/

************ANALYSIS ONE: PREVALENCE OF EACH DISABILITY

*1.  For Group 1 disabilities:
table total [aw=fsweight], c (mean seeing mean hearing mean walking)
table total [aw=fsweight], c (mean selfcare mean communication mean remembering)
*2. For Group 2 disabilities:
table total [aw=fsweight], c (mean learning mean concentrating mean accepting)
table total [aw=fsweight], c (mean controlling mean makefriends mean anxiety)
table total [aw=fsweight], c (mean depression)

**********ANALYSIS 2: REGRESSION


/*Regression: Likelihood of children age 5 to 17 attending school by disability 
status given various socioeconomic factors*/

/*1. For this regression, please make sure to calculate the variables:
attendance from ANAR calculation
DISA_W and DISA_N from children with disabilitiy calculation
Once, all the variables have been calculated, please run the following command
to get the likelihood*/
logit attendance i.anyfuncdi i.DISA_W i.DISA_N i.HL4 i.HH6 i.windex5  i.HH7 i.melevel, or nolog 

