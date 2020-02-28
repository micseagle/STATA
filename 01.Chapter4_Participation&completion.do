**Indicators associated with completion**


*****************************ANAR*********************************************************88
*1. The first step is to input the address where the questionnaire data is stored
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"

/*2. To calculate ANAR, data from 'country_Ready' is used*/
use SL_ready,clear

/*3. Please note in data preparation, we calculated age_school for the hl dataset. 
Generate a new variable "age_school" to group children's ages according to level of education
using MICS variable "schage"
[For example, all primary school children of the correct school age bracket (as defined by the national policy)
will be assigned the value 1- i this it is 6 to 11. Similarly, lower secondary age bracket will be assigned the
value 2- in this case 12 to 14;upper secondary age bracket will be assigned the value 3- in this case 15 to 18.
Label command associated the label value definition to variable. ] */

/*gen age_school=. 
replace age_school=1 if (schage>=6&schage<=11)
replace age_school=2 if (schage>=12&schage<=14)
replace age_school=3 if (schage>=15&schage<=18)
lab def lab_age_sch  1 "Primary" 2 "Lower secondary" 3 "Upper secondary"
lab val age_school lab_age_sch*/

/* 4. Generate a dummy variable "attendance" to calculate attendance according to the grouping created in step 3.
 ["attendance=1" shows if the individual attended the relevant level ;
 "attendance=0" shows that the individual did not attend the level] */
gen attendance=0 if age_school!=.

/* 5. Replace attendance values based on MICS variable for each level of education. For ANAR, the relevant MICS variable are: 
a. ED9 which has information on whether the child attended the school in the relevant year. 
[ED9==1 means the child attended school whreas ED9==2 means that child did not attend school]
b. ED10A shows the level the child reported to attend in that year.
[The command "tab ED10A" and "tab ED10A, nol" shows what level of education each values represents.
Usually, ED10A==1 denotes that the child attended primary; ED10A==2 denotes that the child attendedlower secondary 
and ED10A==3 denotes that the child attended upper secondary]*/
replace attendance=1 if age_school==1&ED9==1&(ED10A==1|ED10A==2) 
replace attendance=1 if age_school==2&ED9==1&(ED10A==2|ED10A==3) 
replace attendance=1 if age_school==3&ED9==1&(ED10A==3|ED10A==4|ED10A==5)

/*6. The result for ANAR per level of education is displayed by the following command  */
table age_school [aw=hhweight], c (mean attendance)
/*The above command asks Stata to display the mean attendance by education level (using age_school grouping in 
a table and applying fsweight */
/*7. Tabulations can also be made based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles
foreach var of var total HL4 HH6   hh7r melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean attendance)
} */
table age_school HH7 [aw=hhweight], c (mean attendance)


******************************NAR*****************************************

/*1.  If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"*/

/*2. To calculate NAR, data from the country_Ready is used*/
use SL_ready,clear

/*3. Please note in data preparation, we calculated age_school for the hl dataset. 
Generate a new variable "age_school" to group children's ages according to level of education
using MICS variable "schage"
[For example, all primary school children of the correct school age bracket (as defined by the national policy)
will be assigned the value 1- i this it is 6 to 11. Similarly, lower secondary age bracket will be assigned the
value 2- in this case 12 to 14;upper secondary age bracket will be assigned the value 3- in this case 15 to 18.
Label command associated the label value definition to variable. ] */

/*gen age_school=. 
replace age_school=1 if (schage>=6&schage<=11)
replace age_school=2 if (schage>=12&schage<=14)
replace age_school=3 if (schage>=15&schage<=18)
lab def lab_age_sch  1 "Primary" 2 "Lower secondary" 3 "Upper secondary"
lab val age_school lab_age_sch*/

/* 4. Generate a dummy variable "attendance" to calculate attendance according to the grouping created in step 3.
 ["nar=1" shows if the individual attended the relevant level ;
 "nar=0" shows that the individual did not attend the level] */
gen nar=0 if age_school!=.

/* 5. Replace attendance values based on MICS variable for each level of education. For ANAR, the relevant MICS variable are: 
a. ED9 which has information on whether the child attended the school in the relevant year. 
[ED9==1 means the child attended school whreas ED9==2 means that child did not attend school]
b. ED10A shows the level the child reported to attend in that year.
[The command "tab ED10A" and "tab ED10A, nol" shows what level of education each values represents.
Usually, ED10A==1 denotes that the child attended primary; ED10A==2 denotes that the child attendedlower secondary 
and ED10A==3 denotes that the child attended upper secondary]*/
replace nar=1 if age_school==1&ED9==1&(ED10A==1) 
replace nar=1 if age_school==2&ED9==1&(ED10A==2) 
replace nar=1 if age_school==3&ED9==1&(ED10A==3)

/*6. The result for NAR per level of education is displayed by the following command  */
table age_school [aw=hhweight], c (mean nar)
/*The above command asks Stata to display the mean attendance by education level (using age_school grouping in 
a table and applying hhweight */
/*7. Tabulations can also be made based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles
foreach var of var total HL4 HH6   hh7r melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean nar)
} */

********************************GAR*******

/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"*/

/*2. To calculate NAR, data from the country_Ready is used*/
use SL_ready,clear
 /*3.  Please note in data preparation and ANAR above, we calculated age_school for the hl dataset. 
Generate a new variable "age_school" to group children's ages according to level of education
using MICS variable "schage"
[For example, all primary school children of the correct school age bracket (as defined by the national policy)
will be assigned the value 1- i this it is 6 to 11. Similarly, lower secondary age bracket will be assigned the
value 2- in this case 12 to 14;upper secondary age bracket will be assigned the value 3- in this case 15 to 18.
Label command associated the label value definition to variable. ] */

/*gen age_school=. 
replace age_school=1 if (schage>=6&schage<=11)
replace age_school=2 if (schage>=12&schage<=14)
replace age_school=3 if (schage>=15&schage<=18)
lab def lab_age_sch  1 "Primary" 2 "Lower secondary" 3 "Upper secondary"
lab val age_school lab_age_sch*/

/*4. Calculate Gross attendance ratio for each level   */
table age_school [aw=hhweight], c (mean ED10A)




*********************Completion rates****************************************************
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/

*2 For completion rate, use the file prepared in data preparation titled COUNTRY_ready
use laos_ready,clear

/*3. Generate a new variable "age_comp" to group children according to the ages-relevant for completion rate by 
education level using MICS variable "schage". For example in Lao PDR, 13 to 15 year olds are expected to complete
primary education and therefore they will be grouped together and assigned the value 1. Similarly, 17 to 19 year olds are expected
 to complete lower secondary education, and are grouped together with the assigned value 2.
For upper secondary, 20 to 22 year  olds are expected to complete upper secondary education and are
 grouped together with the assigned value 3.*/
gen age_comp=. 
replace age_comp=1 if (schage>=13&schage<=15)
replace age_comp=2 if (schage>=17&schage<=19)
replace age_comp=3 if (schage>=20&schage<=22)
lab def lab_age_comp  1 "Primary" 2 "Lower secondary" 3 "Upper secondary"
lab val age_comp lab_age_comp

/*4. Generate a dummy variable "complete" to calculate completion according to the grouping created in step 3.
 ["complete=1" shows if the individual completed the relevant level ;
 "complete=0" shows that the individual did not complete the level]
 First, generate coplete=0  and then proceed to step 5.*/
gen complete=0 if age_comp!=.

/*5. Identify completion based on MICS variable for each level of education. For completion the relevant variables
 are: a.ED5A which indicates the highest level of education attended
 ["tab ED5A" and "tab ED5A, nol" to identify what value is assigned to each level. Usually, ED5A==1 represents primary;
 ED5A==2 represents lower secondary; and ED5A==3 represents upper secondary]
 b. ED5B indicates highest grade attended in that level
 ["tab ED5B ED5A" to check what the highest grade for each level of education is. In this case, for primary ED5B==15;
 for lower secondary it is ED5B==24; and for upper secondary it is ED5B==33]
 c. ED6 shows whether the individual completed that level
 [ED6A==1 indicates that the individual completed the relevant level; ED6A==2 indicates that the individual did not]*/      
replace complete=1 if age_comp==1 & (ED5A==1&ED6==1&ED5B==15)
replace complete=1 if age_comp==1 & (ED5A>=2&ED5A<=5)
replace complete=1 if age_comp==2 & (ED5A==2&ED6==1&ED5B==24)
replace complete=1 if age_comp==2 & (ED5A>=3&ED5A<=5)
replace complete=1 if age_comp==3 & (ED5A==3&ED6==1&ED5B==33)
replace complete=1 if age_comp==3 & (ED5A>=4&ED5A<=5)

*6. The following command shows completion rate per level of education
table age_comp [pw=hhweight], c (mean complete)
/*The above command asks Stata to display the mean completion by education level (using age_comp grouping in 
a table and applying hhweight */

/*7. Tabulations can also be made based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles
foreach var of var total HL4 HH6   hh7r melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean complete)
}*/



 
 
**************************************PARTICIPATION IN ORGANIZED LEARNING
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/

*2. For participation rate in organised learning, use the file prepared in data preparation titled COUNTRY_ready
use laos_ready,clear

/*3. As participation rate in organised learning only focuses on children who are one
 year younger than the official entry age, we only keep children of relevant age */
keep if schage==5

/*4. Generate a new dummy variable "orga_learning".
[orga_learning=0 indicates that the child did not attend pre-primary or primary school
orga_learning=1 indicates that the child attended pre-primary or primary school*/
gen orga_learning=0

/*5. Identify participation rate in organized learning based on MICS variables. The relevant MICS variable is: 
ED10A which shows the level the child reported to attend in that year.
[The command "tab ED10A" and "tab ED10A, nol" shows what level of education each values represents.
Usually, ED10A==0 denotes that the child attended pre-primary and ED10A==1 denotes that the child attended primary]   */
replace orga_learning=1 if ED10A==0|ED10A==1

*6. The following commans shows participation rate in organized learning
table schage [aw=hhweight], c (mean orga_learning)
/*The above command asks Stata to display the mean participation rate in organized learning for the relevant schage
using hhweights*/

/*7. Tabulations based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles

foreach var of var total HL4 HH6   hh7r melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean orga_learning)
}*/




*********************OUT OF SCHOOL CHILDREN****************************
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
 The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/

*2. For out of school children, use the file prepared in data preparation titled COUNTRY_ready
use laos_ready,clear


/* 3. IF YOU FOLLOWED a. ALL THE STEPS FROM THE DATA PREP FILE or b. FOLLOWED STEP 3
FROM ANAR CALCULATION ABOVE
THEN THE VARIABLE 'age_school', SHOULD BE PRESENT IN YOUR DATASET AND THEREFORE YOU ARE NOT 
REQUIRED TO DO THIS STEP. IF IT IS NOT, PLEASE DELETE THE '/' AND '*' FROM THE COMMAND BELOW.

Generate a new variable "age_school" to group children's ages according to level of education
[For example, all primary school children of the correct school age bracket (as defined by the national policy)
will be assigned the value 1. Similarly, lower secondary age bracket will be assigned the value 2;
upper secondary age bracket will be assigned the value 3.] */
/*gen age_school=. 
replace age_school=0 if (schage==5)
replace age_school=1 if (schage>=6&schage<=11)
replace age_school=2 if (schage>=12&schage<=14)
replace age_school=3 if (schage>=15&schage<=18)
lab def lab_age_sch 0 "Pre-primary" 1 "Primary" 2 "Lower secondary" 3 "Upper secondary"
lab val age_school lab_age_sch*/

/* 4. Generate a dummy variable "oos" to calculate out-of-school children according to the grouping created in step 3.
 ["oosc=1" shows if the individual was out of school ;
 "oosc=0" shows that the individual was not out of school] 
DIOGO's command: gen oosc=0 if ED9==1
replace oosc=1 if ED9==0
I am changing this to match others*/

gen oos=0 if age_school>=1&age_school<=3

/*5. Replace out-of-school children values based on MICS variables. The relevant MICS variable are:
ED9 which has information on whether the child attended the school in the relevant year. 
[ED9==1 means the child attended school whereas ED9==2 means that child did not attend school]
ED4 which has information on whether the chil ever attended ECE
ED10A which has information on current education level
ED5A which has informationn on highest level of education
ED5B which has information on highest grade attended
ED6 which has information on whether the highest grade of the highest level attended was completed or not    */
replace oos=1 if (age_school>=1&age_school<=3)&(ED9==2|ED4==2)
replace oos=1 if (age_school==2|age_school==3)&ED10A==0
replace oos=0 if age_school==1 & (ED5A==1 & ED5B==6 & ED6==1 & ED9==2)
replace oos=0 if age_school==2 & (ED5A==2 & ED5B==3 & ED6==1 & ED9==2)
replace oos=0 if age_school==3 & (ED5A==3 & ED5B==4 & ED6==1 & ED9==2)

/*6. The following command shows OOSC rate per level of education */
table age_school [aw=hhweight], c (mean oos) f(%9.2f) 
/*The above command asks Stata to display the mean OOSC by level of education using relevant school age and applying hhweights*/

/*7. Tabulations based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles

foreach var of var total HL4 HH6   hh7r melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean oosc)
}*/


************************EFFECTIVE TRANSITION
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command.
The first step is to input the address where the questionnaire data is stored*/
/*cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"*/
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"
*2. For effective transition from primary to secondary, use the file prepared in data preparation titled COUNTRY_ready
use SL_ready,clear

/*3. Generate a new dummy variable "transition".
[transition=0 will indicate all children that attended the last grade of primary last year
transition=1 will indicate all children who are now attending first grade of secondary]*/
gen transition=.

/*4. Identify effective transition rate based on MICS variables. 
The relevant MICS variables for identifying children who attended last grade of primary last year are:
a. ED16A shows the level of education attended in the previous school year.
[The command "tab ED16A" and "tab ED16A, nol" shows what level of education each values represents.
Usually, ED16A==1 denotes that the child attended primary school in the previous year]
b. ED16B shows the grade of education attended in the previous year.
[The command "tab ED16B ED16A" lets you check the value assigned to the first grade of lower secondary education. 
In this case, 6 has been assigned to it]
*/
replace transition=0 if ED16A==1&ED16B==6

/* 5. The relevant variables for identifying those who attended last grade of primary and are now in first grade of lower
secondary are
a. ED16A shows the level of education attended in the previous school year.
[The command "tab ED16A" and "tab ED16A, nol" shows what level of education each values represents.
Usually, ED16A==1 denotes that the child attended primary school in the previous year]
b. ED16B shows the grade of education attended in the previous year.
[The command "tab ED16B ED16A" lets you check the value assigned to the first grade of lower secondary education. 
In this case, 6 has been assigned to it]
c. ED10A which shows the level the child reported to attend in that year.
[The command "tab ED10A" and "tab ED10A, nol" shows what level of education each values represents.
Usually, ED10A==2 denotes that the child attended lower secondary]
d. ED10B shows the grade of education attended in the current year
[The command "tab ED10B ED10A" lets you check the value assigned to the first grade of lower secondary education. 
In this case, 1 has been assigned to it] */
replace transition=1 if ED16A==1&ED16B==6&ED10A==2&ED10B==1

/*6. The following command shows transition from last grade of primary to first grade of lower secondary */
table total [aw=hhweight], c (mean transition) f(%9.2f) 
/*The above command asks Stata to display the mean transition for the total population by applying hhweight*/

/*7. Tabulations based on socioeconomic and demographic factors. These are:
HL4 represents gender 
HH6 represents urban/ rural
hh7r reperents region
melevel represents mother's education level
ethnicity represents the various etnicities
windex5 represents the different wealth quintiles
foreach var of var total HL4 HH6 melevel ethnicity windex5  {
table `var' [aw=hhweight], c (mean transition)
}*/
 
 
********************** GROSS INTAKE RATIO TO THE LAST GRADE AND PARITY INDICES
***Gross intake ratio to last grade primary
cd "C:\Users\smishra\UNICEF\Diogo Amaro - MICS-EAGLE\Sierra Leone\Data"
use SL_ready, clear
*Generating primary completion age=11 for denominatior 
gen prim_comp_age=.
replace prim_comp_age=1 if schage==11

*For numerator: 
gen last_grade_repeater=0 if ED10A==1&ED10B==6
replace last_grade_repeater=1 if (ED10A==1&ED10B==6&ED16A==ED10A&ED16B==ED10B)

gen gir_primary=0
replace gir_primary=1 if  (ED10A==1&ED10B==6&last_grade_repeater==0)

table prim_comp_age  [pw=hhweight], c (mean gir_primary) f(%9.2f)

