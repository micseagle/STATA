****************Internal Efficiency Indicators

*********************************************School readiness
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"*/
/*2.For school readiness, use the COUNTRY_ready dataset*/
use laos_ready,clear
/*3.Check the code for first grade of primary using ED10A level attended in previous year
ED10B grade attended in previous year*/
tab ED10A
tab ED10A, nol
tab ED10B
tab ED10B,nol
tab ED10B ED10A
/*4. From step 3, we know that in Laos ED10A==1&ED10B==11 represents the
first grade of primary.
Generate a new variable for observations that are reported to be in first grade
 Generate a new variable "readiness" to identify children children relevant for the
 calculation of the indicator.
 [readiness=0 indicate children who are currently attending primary but did not attend ECE
 readiness=1 indicate children who are currently attending primary but did attend ECE]*/
gen readiness=0 if ED10A==1&ED10B==11 
/*5. Replace the value for those observations that attended ECE
in previous year using ED16A. 
Note: Please use 'tab ED16A', 'tab ED16A, nol' to check which digit stands for ECE.*/
replace readiness=1 if ED10A==1&ED10B==11&ED16A==0 /*numerator*/
/*6. The following command gives readiness by wealth. You can use other socioeconomic factors as well*/
table windex5 [pw=hhweight], c (mean readiness) f(%9.2f) 


******************************************************REPETITION RATE
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/
/*2.For repetition rate, use the COUNTRY_ready dataset*/
use laos_ready,clear
/*3. Generate repeaters as those who are attending same level this year
[repeat=0 identifies all children who attended education in the previous year
repeat=1 indicates all children who repeated a grade in a level in the previous year]
*/
gen repeat=0 if ED16A!=.
/*4. Replace the values for the variable "repeat" based on MICS variables. The relevant
MICS variables are: 
a. ED16A which has the information on the level attended by individual in 
the previous year; 
b. ED10A which has the information on the level attended in the current year
c. ED16B which has information on the grade attended in the previous year
c. ED10B which has information on the grade attened in the current year */
replace repeat=1 if (ED16A==ED10A)&(ED16B==ED10B)&ED16A!=.
*5.Repetition by grade attended in the previous year (t-1)
table ED16B [pw=hhweight], c (mean repeat) 



*****************************************************DROPOUT RATE
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/
/*2.For dropout rate, use the COUNTRY_ready dataset*/
use laos_ready,clear
/*3. Generate dropout as those who are not in school in the current year
[dropout=0 identifies all children who are in school currently
repeat=1 indicates all children who are not in school this year but were in school 
in the previous year]*/
gen dropout=0
/*4. Replace the value for dropout using MICS variables. The relevant MICS variable is:
ED9 which has information on whether the child is attending school or not
[ED9==1 means the child attended school whereas ED9==2 means that child did not attend school.]  */
replace dropout=1 if ED9!=1
/* please note "!" refers to not. Therefore the command will read replace 
dropout=1 if ED9 is not equal to 1- meaning they are not in school.*/

*5. Dropout by grade attended in the previous year (t-1)
table ED16B [pw=hhweight], c (mean dropout) 


************************Over-age students for grade
/*1. If starting from scratch, please delete the "/" and "*" at the beginning and 
end of the command
The first step is to input the address where the questionnaire data is stored*/
/*cd "C:\Users\damaro\OneDrive - UNICEF\MICS-EAGLE\Laos\Data"*/
/*2.For over-age students for grade, use the COUNTRY_ready dataset*/
use laos_ready,clear
/*3. Generate a new variable "overage" for calculating the students who are atleast two years overage for grade.
overage=0 represents all children in primary, lower secondary and upper secondary
overage=1 represents all children who are older than the official school age 
identified for the grade*/
gen overage=0 if ED10A==1|ED10A==2|ED10A==3

/* 4.Replace the values in the variable overage using MICS variables. The relevant MICS variables are: 
a. ED10A which shows the level the child reported to attend in that year.
[The command "tab ED10A" and "tab ED10A, nol" shows what level of education each values represents.
Usually, ED10A==1 is for primary, ED10A==2 for lower secondary and ED10A==3 for upper secondary]
b.ED10B shows the grade of education attended in the current year
[The command "tab ED10B ED10A" lets you check the value assigned to the grades across the different levels of education. 
In this case, Grade 1 primary has been assigned 11, grade 2 has been assigned 12, grade 3 has been assigned 13 and so on]
c. schage refers shows the school age at the beginning of the school year.
[The official school age for each level and grade 
is provided in the national education policy. In this case children whose school age is 6 should be attending grade 1
of primary and therefore for overage, the command uses shage greater than 8 for grade 1 in primary. Similarly, for grade 2, the official 
school age is 7 therefore to be overage, schage would be 9 or greater.]
  */
replace overage=1 if ED10B==11&schage!=.&schage>8
replace overage=1 if ED10B==12&schage!=.&schage>9
replace overage=1 if ED10B==13&schage!=.&schage>10
replace overage=1 if ED10B==14&schage!=.&schage>11
replace overage=1 if ED10B==15&schage!=.&schage>12
replace overage=1 if ED10B==21&schage!=.&schage>13
replace overage=1 if ED10B==22&schage!=.&schage>14
replace overage=1 if ED10B==23&schage!=.&schage>15
replace overage=1 if ED10B==24&schage!=.&schage>16
replace overage=1 if ED10B==31&schage!=.&schage>17
replace overage=1 if ED10B==32&schage!=.&schage>18
replace overage=1 if ED10B==33&schage!=.&schage>19
*5. Tabulation for Over-age per grade
table ED10B [aw=hhweight], c (mean overage) f(%9.2f) 

