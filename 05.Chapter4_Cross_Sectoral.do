********************CROSS-SECTIONAL INDICATORS********************

**************************POSTITIVE AND STIMULATING HOME ENVIRONMENT
*1. The first step is to input the address where the questionnaire data is stored
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"
/*2. For positive and stimulating information, the data is stored
in the dataset for children between 5 to 17.*/
use SL_fs_ready,clear
/*3. Recode variable PR5 (if child ever had homework).
"tab PR5" and "tab PR5, nol" will provide the value assigned.
For SL, 
PR5==1 represents child had homework
PR5==2 represents child did not have homework
PR5==8 represents don't know
PR5==9 represents no response
Here, we recode PR5==2 to 0 to simplify the calculation of share
of children who received homework*/
replace PR5=0 if PR5==2
replace PR5=. if PR5==8|PR5==9
/*4. Repeat the same for PR6 (anyone helps child with homework)
use "tab PR6" and "tab PR6, nol" to check the values assigned.
For SL, 
PR5==1 represents child had help with homework
PR5==2 represents child did not have help with homework
PR5==8 represents don't know
PR5==9 represents no response*/
replace PR6=0 if PR6==2
replace PR6=. if PR6==8|PR6==9
/*5. Show the share of children who had homework and those who received help
using different socioeconomic and demographic characteristics:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles*/
foreach var of var HL4 HH6 HH7 melevel ethnicity windex5  {
table `var' [aw=fsweight], c (mean PR5 mean PR6) row f(%9.2f)
}



**PARENTAL INVOLVEMENT
/*Delete '/*' and '*/' to redo step one and two if starting a new file. 
1. The first step is to input the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"
2. For parental engagement, the data is stored
in the dataset for children between 5 to 17
use fs,clear*/
/*3. Harmonizing variables to calculate parental engagement, the variables are: 
PR6 has information on whether someone helped child with homework
PR7 has information on whether child's school has governing body
PR8 has information on whether parent attended a school meeting
PR9A has information on whether parents met with teacher to address child's difficulties
PR9B has information on whether parents discussed budget with child
PR11A has information on whether parents attended celebration in the past 12 months
PR11B has information on whether parents went to school to discuss child's progress.
Use 'describe' and 'tab' command to explore these variables for your country */
foreach var of var PR6  PR7 PR8  PR9A  PR9B  PR11A PR11B {
replace `var'=0 if `var'==2|`var'==8|`var'==9
}
/*4 Recode variables PR8, PR9A and PR9B. This is because PR8 is a subgroup of PR7, and PR9A and
PR9B are subgroups of PR8, and therefore we recode them to address
any discrepancy in data*/
replace PR8=0 if PR7==0
replace PR9A=0 if PR8==0
replace PR9B=0 if PR8==0
/*5. Use any of the parental engagement variables with socioeconomic and demographic
variables to show their variations. Here, PR9A and PR9B is used. The analysis
can be repeated for PR6, PR7, PR8, PR11A and PR11B as well. The soceioecononmic variables are: 
HH6 represents urban/ rural
HH7 reperents region
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles*/
foreach var of var HH6 windex5  HH7{
table `var'  [pw=fsweight], c (mean PR9A mean PR9B) f(%9.2f) 
}


**CHILD LABOR

/*Delete '/*' and '*/' to redo step one and two if starting a new file. 
1. The first step is to input the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Sierra Leone\Data"
2. For child labor, the data is stored
in the dataset for children between 5 to 17
use SL_fs_ready,clear*/
*********CHILD LABOR RELATED TO ECONOMIC ACTIVITIES
/*3. Create a new variable for children who worked in economic activities. This occurs if:
 CL1A==1 represents child worked or helped in garden
 CL1B==1 represents child helped in family business
 CL1C==1 represents child produced or sold articles
 CL1X==1 represents child engaged in any other activity for income*/
gen childw=. 
foreach var of var CL1A CL1B CL1C CL1X {
replace childw=0 if `var'!=.&childw!=1
replace childw=1 if `var'==1
}
/*4. The second condition to count for child labour for economic activities
is given by the number of hours worked by age.To do so, create a new variable based on age (CB3)
and number of hours worked CL3. */
gen childlaec=0 if childw!=.
replace childlaec=1 if childw==1&CB3<=11&CL3>=1&CL3!=.
replace childlaec=1 if childw==1&CB3<=14&CL3>=14&CL3!=.
replace childlaec=1 if childw==1&CB3<=17&CL3>=43&CL3!=.
**********CHILD LABOR RELATED TO HOUSEHOLD CHORES
/*5.Information on child labour related to household task can be found in (All activities
for the passt week):
CL7==1 represents child fetched water 
CL9==1 represents child collected firewood 
CL11A==1 represents child participated in household chore: shopping
CL11B==1 represents child participated in household chore: cooking
CL11C==1 represents child participated in household chore: washing dishes or cleaning
CL11D==1 represents child participated in household chore: washing clothes
CL11E==1 represents child participated in household chore: caring for children
CL11F==1 represents child participated in household chore: caring for old or sick
CL11X==1 represents child participated in household chore: other household task
You can use the 'des' and 'tab' command to explore these variables.
If any of the variable equals one, child is assumed to engage in household chores
*/
gen childhh=. 
foreach var of var CL7 CL9 CL11A CL11B CL11C CL11D CL11E CL11F CL11X {
replace childhh=0 if `var'!=.&childhh!=1
replace childhh=1 if `var'==1
}
/*6. The second condition to count for child labour in household activties is 
given by number of hours. Generate a new variable to, first, account for number of 
hours spend in household activties, using:
 CL8(hours for fetching water);
 CL10 (hours for collecting firewood)
 CL13 (Number of hours in household chores)
calculate total number of hours on household chores*/
gen hourshh=0
foreach var of var CL8 CL10 CL13 {
replace `var'=0 if `var'==.
replace hourshh=hourshh+`var'
replace `var'=. if `var'==0
}
/*7. Input values for child labour for household chores if the number of hours
worked is beyond the age specific threshold using 'age', and the new variable
generate in step 6. */
gen childlahh=0 if childhh!=.
replace childlahh=1 if childhh==1&CB3<=14&hourshh>=28&hourshh!=.
replace childlahh=1 if childhh==1&CB3<=17&hourshh>=43&hourshh!=.
*****************CHILD LABOR RELATED TO HAZARDOUS CONDITIONS
/*8. Information on child labour in hazardous condition can be found in (All activities
for the passt week):
CL4==1 represents child engaged in activity requiring carrying heavy leads
CL5==1 represents child engaged in activity requiring working with dangerous/heavy tools 
CL6A==1 represents child engaged in work which exposed them to dust, fume or gas
CL6B==1 represents child engaged in work which exposed them to extreme temperature or humidity
CL6C==1 represents child engaged in work which exposed them to loud noise or vibration
CL6D==1 represents child participated in work which required them to work at heights
CL6E==1 represents child participated in work which required them to work with chemicals
CL6X==1 rrepresents child engaged in work which exposed them to any other harmful substances or scenarios
You can use the 'des' and 'tab' command to explore these variables.
If any of the variable equals one, child is assumed to engage in working in hazardous conditions
There is no time or age dimension to account for this. 
*/
gen hazard=0 if childw!=.
foreach var of var CL4 CL5 CL6A CL6B CL6C CL6D CL6E CL6X {
replace hazard=1 if `var'==1
}
*****************Total child labour
/*9.  Generate a new variable to account for child labour. 
If child labor in any of the 3 dimensions equals 1, then chil is assumed
to be engaging in labor. */
gen childlatotal=.
foreach var of var childlahh childlaec hazard { 
replace childlatotal=0 if `var'!=.&childlatotal!=1
replace childlatotal=1 if `var'==1
}
/*10.Suggested tabulations for child labour can use CB3(age), current level of education(CB8A)  */
table CB8A [aw=fsweight], c (mean childlatotal) f(%9.2f)
/*11. Check for the share of the three types using the following commans*/
table childlatotal [aw=fsweight], c (mean childlaec mean childhh mean hazard) f(%9.2f)


******************************EARLY MARRIAGE
/*Delete '/*' and '*/' to redo step one and two if starting a new file. 
1. The first step is to input the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Sierra Leone\Data"

2. Use the file from data preparation which has the merged dataset for men and women
Please note you can do these steps only for women and use the women dataset instead*/
use SL_ready,clear
/*3. Generate a variable for early marriage if men or women responded to the
question on marriage. 
If deriving only for women use 'MA1', and if only for men use 'MMA1'*/
gen early_marriage=0 if MA1!=.|MMA1!=.
/*4.Generate a variable for married when 15, and make it 0 if early marriage is 0 */
gen early15=0 if early_m==0
/*5.Generate a variable for married when 18, and make it 0 if early marriage is 0 */
gen early18=0 if early_m==0
/*6. Based on age at first marriage (WAGEM in women's dataset and MWAGEM in men's dataset) 
input the value for variables created in steps 4 and 5. */
replace early15=1 if WAGEM<=14|MWAGEM<=14
replace early18=1 if (WAGEM>=15&WAGEM<18)|(MWAGEM>=15&MWAGEM<18)
/*7. Men or women are assumed to be married early if they marry before 18. 
For better disaggregation, use marriage before 15 as well.  */
replace early_m=1 if early15==1
replace early_m=2 if early18==1
/*8.Define label values, as follows */
lab def lab_early_m  0 "No early marriage" 1 "Married < 15" 2 "Married 15 and 18"
/*9. Associate label values with variable*/
lab val early_m lab_early_m
/*10. Simple tabulation*/
tab welevel early_m


***********************************CHILD FUNCTIONING//DISABILITY
/*Delete '/*' and '*/' to redo step one and two if starting a new file. 
1. The first step is to input the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Sierra Leone\Data"
2. For child labor, the data is stored
in the dataset for children between 5 to 17*/
use SL_fs_ready, clear
/*3. Generate variables by disabilities identified by the Washington Consensus, if the 
interview with child was completed(FS17==1)  */
foreach var in seeing hearing walking selfcare communication learning remembering /*
*/ concentrating accepting controlling makefriends anxiety depression anyfuncdi {
gen `var'=0 if FS17==1
lab val `var' ca_labels
}
/*4. Replace values for disabilities based on responses stored in different variables.
You can explore each of these variables (FCF6, FCF8, FCF10, FCF11, FCF14, FCF15, FCF16, FCF17,
FCF18, FCF19, FCF20, FCF21, FCF22, FCF23, FCF24, FCF25, FCF26) using 'tab', 'tab, nol' and 'des' commands */
replace seeing=1 if FCF6==3|FCF6==4
replace hearing=1 if FCF8==3|FCF8==4
replace walking=1 if FCF10==3|FCF10==4|FCF11==3|FCF11==4|FCF14==3|FCF14==4|FCF15==3|FCF15==4
replace selfcare=1 if FCF16==3|FCF16==4
replace communication=1 if FCF17==3|FCF17==4|FCF18==3|FCF18==4
replace learning=1 if FCF19==3|FCF19==4
replace remem=1 if FCF20==3|FCF20==4
replace conc=1 if FCF21==3|FCF21==4
replace acce=1 if FCF22==3|FCF22==4
replace contro=1 if FCF23==3|FCF23==4
replace makef=1 if FCF24==3|FCF24==4
replace anxi=1 if FCF25==1
replace depre=1 if FCF26==1
/*5.Child disability exists if any of the variables in step equals to 1 */
foreach var in seeing hearing walking selfcare communication learning remembering concentrating accepting controlling makefriends anxiety depression  {
replace anyfunc=1 if `var'==1
}
/*6. For better analysis, we can also group child disability */
gen DISA_WGSS=0
foreach var in seeing hearing walking selfcare communication remembering {
replace DISA_WGSS=1 if `var'==1
}
gen DISA_NewDomain=0
foreach var in learning concentrating accepting controlling makefriends anxiety depression  {
replace DISA_NewDomain=1 if `var'==1
}
/*7. Some tabulations for child disability.
Please note the variable attendance used below is calculated for ANAR. 
Please refer to the do file on completion indicators to esnure your dataset has already calculated it  */ 
foreach var of var HL4 HH6  HH7 windex5 attendance  {
table `var' [aw=fsweight], c (mean anyfunc mean DISA_WGSS mean DISA_NewDomain)
}
