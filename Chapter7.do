
**********************CHAPTER 7

***PROMOTING ECE: Education level attended among children between the ages of 3 and 6 
/*1. Input the directory where the data is stored
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country_data\MICS6\Laos"*/
/*2. Use Country_ready dataset*/
use laos_ready, clear
/*3. Create a new variable for children between ages 3 to 6*/
gen level_early=0 if  schage>=3&schage<=6
/*4 Replace the value to 1 if child attended ECE in the current year
or replace the value to 2 if child attended primary */
replace level_early=1 if (schage>=3&schage<=6)&ED10A==0
replace level_early=2 if (schage>=3&schage<=6)&ED10A==1
/*5. Define the label where 0 is out of school, 1 is ECE and 2 is Primary */
lab def lab_early  0 "Out of school" 1 "ECE" 2 "Primary" 
/*6. Link the label values to definition */
lab val level_early lab_early
/*7. Tabulate the result*/
tab level_early  HL6  [aw=hhweight] if level_early!=., col nofreq

*************Learning outcomes of ECE: Lao PDR ECDI
/*Please make sure you calculate the ECDI indicator from file Chapter 4_Devleopment and skills, Line 3-100 */
/*1. Generate a new variable att_ece  for all children of age 36 months to 59 months */
gen att_ece=0 if (CAGE>=36&CAGE<=59)
/*2. Replace att_ece to 1 if child attended ECE given by UB8==1*/
replace att_ece=1 if (CAGE>=36&CAGE<=59)&UB8==1
/*3. Tabulate literacy-numeracy by att_ece.
Replace the mean of lit-numeracy by other ECDI dimensions for further analysis  */
foreach var of var total HL4 HH6 UB2 UB8 cdisability  {
table  `var' att_ece  [pw=chweight], c (mean lit_num) f(%9.2f) 
}

*****************Grade Repitition by grade
/*Please make sure that repetition has been calculated from file 'Chapter4_Internal_Efficiency" line 33-54
If not, please follow the steps from the do file containing it.

Repetition is calculated using country_ready dataset
After the indicator has been calculated you can run the following command
to get repeptition by grade*/
table ED10B [pw=hhweight] if ED10B<=36, c (mean repeat)


*********************Repeaters at grade 1 by age: Lao PDR
/*Please make sure that repetition has been calculated from file 'Chapter4_Internal_Efficiency" line 33-54
If not, please follow the steps from the do file containing it.

Repetition is calculated using country_ready dataset
After the indicator has been calculated you can run the following command
to get repeaters in grade 1

You can tweak the command to cover other grades
Replacing age_g by relevenat ages
and ED10B by the relevant grade*/
*1. Generate a new variable to cover the chilren of various ages in grade 1
gen age_g=.
*2. Replace the values according to school age variable
replace age_g=1 if schage>=0&schage<=5
replace age_g=2 if schage==6
replace age_g=3 if schage==7
replace age_g=4 if schage==8
replace age_g=5 if schage>=9&schage<=18
*3. Only keep the observations from grade 1 and repeat not missing
keep if ED16B==11&repeat!=.
*4. Create the tabulation for repeat
collapse (sum) hhweight, by (age_g repeat)
egen total=sum(hh),by (repeat)
replace hh=100*hh/tot
drop tot
reshape wide hh, i(age) j(rep)
*6. Coloums hhweight0 has the results for non-repeaters whereas hhweight1 has the results for repeaters

***Do children with disabilities attend school?
/**First define and calculate disability from Chapter4Cross sectoral indicators file, line 211-259
*Then, calculate prevalence of disability calculated Chapter6 line 77-88
*/
/*The indicator uses the country_fs_ready dayaset.
In the indicator calculation, some cross-tabulations are listed.*/

*1.  For Group 1 disabilities:
table total [aw=fsweight], c (mean seeing mean hearing mean walking)
table total [aw=fsweight], c (mean selfcare mean communication mean remembering)
*2. For Group 2 disabilities:
table total [aw=fsweight], c (mean learning mean concentrating mean accepting)
table total [aw=fsweight], c (mean controlling mean makefriends mean anxiety)
table total [aw=fsweight], c (mean depression)
*3. For any disability
table total [aw=fsweight], c (mean anyfunc)

******Attendance by disability

use SL_fs_ready,clear
*The command below will give attendance by disability
foreach var in seeing hearing walking selfcare communication learning remembering /*
*/ concentrating accepting controlling makefriends anxiety depression anyfuncdi{
preserve
table `var'  [pw=fsweight], c (mean attendance) replace
restore
}


***How much do children learn: SL
**Chapter4_Development_and_skills line 102-207

****Learning by grade
/*Use the code to first calculate reading and numeracy skill
The code can be found in chapter4_Development_and_skills, line 102-207
Run the commands below after calculating the indicators*/

*1. gen grade variable, for different grades and school attendance
gen grade=.
replace grade=0 if att==0
replace grade=1 if CB5A==1&CB5B==1
replace grade=2 if CB5A==1&CB5B==2
replace grade=3 if CB5A==1&CB5B==3
replace grade=4 if CB5A==1&CB5B==4
replace grade=5 if CB5A==1&CB5B==5
replace grade=6 if CB5A==1&CB5B==6
replace grade=7 if CB5A==2
keep if readsk!=.&att!=.

*2. Calculate the mean in skills by grade
collapse (mean) readsk numbsk [pw=fsweight], by (grade)
sort grade
*3 Use the data expolorer to copy-paste the results
