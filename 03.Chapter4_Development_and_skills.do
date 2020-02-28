****************DEVELOPMENT AND SKILLS***********************

**EARLY CHILDHOOD DEVELOPMENT INDEX(Laos)
*1. The first step is to imput the address where the questionnaire data is stored
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"

/*2. To calculate ECDI, data from the under-5 questionnaire is used, saved as "ch" and generate a variable for all observations */
use ch,clear
gen total=1

/*3. First, we get rid of all the incomplete questionnaires and keep the information for only.
The relevant MICS variable are:
a. UF17 has information on whether the interview was completed or not
[Usually, UF17==1 indicates that the interview was completed. However, please "tab UF17" and "tab UF17, nol" 
to confirm]
b. UB2 has the age of the child. 
[Please use "tab UB2" and "tab UB2, nol" to confirm the values assigned.
Usually for this indicator we need children older than 36 months and therefore UB2>=3 is the syntax]
*/
keep if UF17==1 
keep if UB2>=3 

/*4. ECDI comprises of four skills. Therefore, generate 4 new variables for each skill: 
a. "lit_num" for literacy and numeracy domain, 
b. "phy" for physical domain,
c. "socio_em" for social and emotional domain; and
d. "learn" for the learning domain   */ 
gen lit_num=0
gen phy=0
gen socio_em=0
gen learn=0

/*5. LIT AND NUMERACY: Replace values for proficiency in "lit_num" using MICS variables. 
The relevant variables are:
a. EC6 which has information on whether the child identifies at least ten letters of the alphabet 
 [EC6==1 means the child was able to execute the task and; EC6==2 means they were not able to execute it]
b. EC7 has information on whether the child was able to read four simple, popular words
[EC7==1 means the child was able to read four simple, popular words and; EC7==2 means they were unable to do so]
c. EC8 has information on whether the child was able to recognize the symbol of all numbers ffrom 1 to 10
[EC8==1 means the child was able to recognize the symbols; EC8==2 means the child was unable to do so]
A child is developmentally on track in literacy-numeracy if they can perform atleast 2 of these tasks.*/
replace lit_num=1 if EC6+EC7+EC8==2|EC6+EC7+EC8==3


/*6. PHYSICAL: Replace values for proficiency in "phy"  using MICS variables. 
The relevant variables are: 
a. EC9 which has information on whether child is able to pick up small objects using two fingers
[EC9==1 means the child was able to pick up the small object using two fingers; EC9==2 means that child was unable to do so
b. EC10   which has information on whether the child was too sick sometimes to play
[EC10==1 means the child was too sick sometimes to play; EC10==2 means the child was not too sick to play]  
A child is developmentally on track in physical if one of the two is true. */
replace phy=1 if EC9==1|EC10==1

/*7. SOCIAL EMOTIONAL: Replace values for proficiency in "socio_em" using MICS variables. 
The relevant variables are: 
a. EC13 which has information on whether child gets along with other children
[EC13==1 means the child does get along with other children; EC13==2 means the child does not get along]
b. EC14 which has information on whether the child kicks, bites or hits other children or adults
[EC14==1 means the child does kick, bite or hit children or adults; EC14==2 means the child does not]
c. EC15  which has information on whether child gets ditracted easily
[EC15==1 means the child does get distracted easily; EC15==2 means the child does not get distracted]
A child is developmentally on track in social and emotional skills if atleast two of the questions are true*/
replace socio_em=1 if EC13+EC14+EC15==2|EC13+EC14+EC15==3

/*8. LEARNING: Replace values for proficiency in "lear" using MICS variables.
The relevant variables are: 
a.  EC11 which has information on whether the child is able to follow simple directions 
[EC11==1 means the child is able to follow simple directions; EC11==2 means the child is unable to follow simple instructions]
b. EC12 which has information on whether the child is able to do things independently
[EC12==1 means the child is able to do things independently; EC12==2 means the child is unable to do things independently]
A child is developmentally on track in learning if atleast one of the question is true */
replace learn=1 if EC11==1|EC12==1


/*9. Generate a new variable "develop" to calculate ECDI. Childrenren are on track if they are on track in atleast three dimensions.
[develop=1 means children are developmentally on track
develop=0 means children are not developmentally on track] */
gen develop=0
replace develop=1 if lit_num+phy+socio+learn==3|lit_num+phy+socio+learn==4


/*10. ECDI for all children will be given by the following command */
table total [pw=chweight], c (mean develop) f(%9.2f) 

/*11. Tabulation to comapre dimension with the total will be giiven by the following command  */
table total [pw=chweight], c (mean lit_num mean phy mean socio mean learn mean develop) f(%9.2f) 

/* Tabulations based on socioeconomic and demographic MICS variables. These are:
a. HL4 represents gender
b. HH6 represents locaion
c. UB2 represents age
d. UB8 represents ECE attendance
e. disability repesents disability  */
foreach var of var total HL4 HH6 UB2 UB8 cdisability  {
table  `var'  [pw=chweight], c (mean lit_num mean phy mean socio mean learn mean develop) f(%9.2f) 
}

/*13.Save this file as the new variables are useful for further analysis */
save SL_ch_ready, replace


********************************LEARNING OUTCOMES
/*1. The first step is to imput the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Sierra Leone\Data"*/

*2 To calculate learning module, data from the five to seventeen year old questionnaire will be used 
use SL_fs_ready, clear

/*3. Generate variables to measure numeracy and liiteracy skills if foundation learning module
was taken. FL29==1 means the interview was completed, and therefore includes the foundational 
module, if the country had opted for it.
The variables being generated are:
FOR LITERACY: 
	target represents the total number of words read;
	read_corr represents reading 90% of the text; 
	alit represents response to the literal questions;
	alnfe represents response to the inferential questions;
	readskill represents foundational literacy skills amongg children.

FOR NUMERACY: 
	target_num represents identifying and reading numbers 
	number_read represents identifying and reading numbers correctly;
	number_dis represents response to number discrimination tasks;
	number_add represents response to addition tasks;
	number_patt represents reponse to number pattern tasks;
	numbskill reperesents foundational numeracy skills among children. */ 
foreach var in target read_corr alit alnfe readskill target_num number_read number_dis number_add number_patt numbskill {
gen `var'=0 if FL29==1
}

/*FOUNDATIONAL LITERACY SKILLS

 To calculate foundation literacy skills (readskill), replace values for read_corr, alit, alnfe. 
read_corr==1 represents child read 90% of words correctly
alit==1 represents child respondes to the three literal question correctly 
alnfe===1 represents child responses to the two inferential question correctly 
Each sub step below relates to this.*/

/* 4a. For read_corr:  First derive the 90% reading target. To do this, replace the values for target based on FL19W  */
foreach num of numlist 1/72 {
replace target=target+1 if FL19W`num'==" "
}
/*4b. Now calculate the value for 90% success. For example, in Sierra Leone there were 72 words, meaning 90% success equals 
64.8 words. */
replace read_corr=1 if target>=64.8&target!=.&FL10==1

/*4c. For alit: Replace values using variable FL22A, FL22B and FL22C related with literal questions from FL module*/
replace alit=1 if FL22A==1&FL22B==1&FL22C==1

/*4d. For alnfe: Replace values using variables FL22D and FL22E related with inferential questions from FL module*/
replace alnfe=1 if FL22D==1&FL22E==1

*5. Calculate foundational reading skills if all tasks are correctly performed
replace readsk=1 if alit==1&read_cor==1&alnfe==1

/*FOUNDATIONAL NUMERACY SKILLS

 To calculate foundation numeracy skills (numbskill), replace values for number_read, number_dis, number_add, number_patt. 
number_read==1 represents child having correctly identified and read all numbers;
number_dis==1 represents child having correctly responded to all number discrimination tasks;
number_add==1 represents child having correctly responded to all number addition tasks
number_patt==1 represents child having correctly responded to all number pattern tasks
Each sub step below relates to this.*/

/*6a. For number_read: First derive whether number reading target was met or not. To do so, replace value for target_num based on 
correctly reading numbers. FL23A==1, FL23B==1, FL23C==1, FL23D==1,FL23E==1,FL23F==1 represents correctly reading that number */
foreach var in FL23A FL23B FL23C FL23D FL23E FL23F {
replace target_num=target_num+1 if `var'==1
}
/*6b. Replace value for number_read if all numbers were read correctly  */
replace number_read=1 if target_num==6

/*6c. For number_dis: Replace values if all number displacement questions were answered correctly. 
 FL24A==1, FL24B==1, FL24C==1, FL24D==1, FL24E==1, FL24F==1 represents correctly answering all number displacement questions*/
replace number_dis=1 if FL24A==1&FL24B==1&FL24C==1&FL24D==1&FL24E==1

/*6d. For number_add: Replace values if number addition questions were answered correctly.
 FL25A==1, FL25B==1, FL25C==1, FL25D==1, FL25E==1, FL25F==1 represents correctly answering all number addition questions */
replace number_add=1 if FL25A==1&FL25B==1&FL25C==1&FL25D==1&FL25E==1

/*6e. For number_patt: Replace values if number pattern questions were answered correctly.
 FL27A==1, FL27B==1, FL27C==1 represents correctly answering all number pattern questions */
replace number_patt=1 if FL27A==1&FL27B==1&FL27C==1


*7. Calculate foundational numeracy skills if all tasks are correct
replace numbskill=1 if number_read==1&number_dis==1&number_add==1&number_patt==1

******NO TABULATIONS

*Simple tabulation
table total [pw=fsweight], c (mean readsk mean numbskill) f(%9.2f) 

*Tabulation for reading skill
table total [pw=fsweight], c (mean read_cor mean alit mean alnfe mean readsk) f(%9.2f) 

*Tabulation for numeracy skill
table total [pw=fsweight], c (mean number_read mean number_dis mean number_add mean number_patt mean numbskill) f(%9.2f) 

/*Tabulation using socio-economic factors. Relevant variables are:
HL4 which represents gender
HH7 represents region
windex5 represents wealth quintile
*/
foreach var of var total HL4 HH7 windex5  {
table `var' [pw=fsweight], c (mean numbskill mean readsk) f(%9.2f) 
}



*************************************ICT SKILLS

/*1. The first step is to imput the address where the questionnaire data is stored
cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Sierra Leone\Data"*/

*2. For ICT skills, use the file prepared in data preparation titled COUNTRY_ready
use SL_ready,clear

/*3. Combining data for men and women: Since there are 9 ICT activities, collected separately for men and women. 
Generate 9 new variables, one for each activity to combine data for men and women. For ease,
create a loop to generate the variables */
foreach var in A B C D E F G H I {
gen ict_`var'=0
replace ict_`var'=1 if MT6`var'==1|MMT6`var'==1
local lbl : variable label MT6`var'
label var ict_`var' `"`lbl'"'
}

/*4. To calculate ICT use, generate a new variable "ict_combined".
[ict_combined=0 represents no ICT-related activity being performed
 ict_combined=1 represents atleast one ICT-related activtiy being performed    */
*Recoding for at least one activity
gen ict_combined=0

/*5. Replace values for ict_combined based on the new variables created in step 3.
"==1" signifies that the activity was performed by individual */
foreach var in A B C D E F G H I {
replace ict_combined=1 if ict_`var'==1
}

*6. Simple tabulation for all age group
table total [pw=nweight], c (mean ict_combined) f(%9.2f)

*Simple tabulation for specific age group 15-24 year olds
table total [pw=nweight] if HL6>=15&HL6<=24, c (mean ict_combined) f(%9.2f)

/*7. Tabulation using socio-economic variables:
HL4 represents gender
HH6 represents location
windex5 represents wealth quintile
*/ 

foreach var in HL4 HH6 windex5 { 
table `var' [pw=nweight] if HL6>=15&HL6<=24, c (mean ict_combined)
}


*8. Generating crosstabs for each skill for young people by gender
foreach var in A B C D E F G H I combined {
table HL4 if  HL6>=15&HL6<=24 [pw=nweight], c (mean ict_`var') f(%9.2f) 
}
*9.Generating crosstabs for each skill for young people by level of education
foreach var in A B C D E F G H I combined {
table ED5A if  HL6>=15&HL6<=24 [pw=nweight], c (mean ict_`var')  f(%9.2f) 
}


**********Literacy rate
*1. The literacy variable was already created in the data prep file
use SL_ready,clear

*2. Simple tabulation for all age group
table total [pw=nweight], c (mean literate) f(%9.2f)

*3. Simple tabulation for specific age group 15-24 year olds
table total [pw=nweight] if HL6>=15&HL6<=24, c (mean literate) f(%9.2f)

*4. Cross-tabulation based on different variables for 15-24 year olds
keep if HL6>=15&HL6<=24
foreach var of var total HL4 HH6 windex5 {
preserve
table `var' [pw=nweight], c (mean literate) f(%9.2f) replace
restore
}


