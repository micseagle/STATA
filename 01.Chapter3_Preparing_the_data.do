/*The following datasets are relevant for education indicators and analysis:
a.  hl: includes data from the following modules- education (ed); insecticide treated nets (tn)
	
*Weight:  'hhweight' for household sampling weight is used for all completion and internal effeciency indicators

b.wm:  dataset contains all information for women  aged 15-49 years, related to ICT and marriage

*Weight: 'wmweight' in the 'wm' dataset is the women's sampling weight 

c. mn:  dataset contains all data from interviews aged 15-49 yearsm related to ICT and marriage
men

*Weight: 'mnweight' in the 'mn' dataset is the men's sampling

d. fs: dataset has all data for one randomly selected child of age 5-17 years in each household

*Weight: 'fsweight' in the 'fs' dataset is the sampling weight for 5-17 year olds which is used
foundational learning and child labor

e. ch: dataset has all the data for children under 5 related to early childhood development index

*Weight: 'chweight' in the 'ch' dataset is the sampling weight for children under 5.*/

 /*PREPARING AND MERGING DATASETS
 Here, we merge hl, mn and wm datasets for convenience of calculating and analysing indicators.
 With this dataset we can calculate all indicators related to completion (hl) and internal effeciency (hl)
 and ICT-related activites (wm and mn) and child marriage(wm and mn)
 
 When merging datasets, be mindful of weights and ensure that the weight variable from each dataset is
 included in the merged dataset. Moreover, if combining data for men and women
 step 35, below, creates a new weight variable 'nweight' which should be used for accurate 
 calculation of any data combining men and women datasets.
 
 Step 29. serves as an example of a way of dealing with missing values*/ 

/*1. All data can be downloaded at: mics.unicef.org/surveys
This tutorial uses the Sierra Leone dataset. But the commands are applicable for all other datasets
Please Input the address where all the data is stored on your computer:*/
cd "\\sipaxafsc\users\sm4557\Desktop\UNICEF\Country data\MICS6\SL"


/*2. Use the HL dataset */
use hl,clear
/*3. Generate, define and assign value to a new variable total to account for total number of observations */
gen total=1 
lab def tot 1 "Total" /*Define the label by creating a value label called tot that associates '1' with total*/
lab val total tot /* This command associates the variable 'total' generated in line 17 with the label 'tot' defined in line 18  */
********
/*4. Generating a new variable to group children by official school age bracket according to education level*/
gen age_school=. 
/*5.  Assigning value for primary education: For primary education, assign 1 to official age bracket for primary level. 
In Sierra Leone this means all children of age 6 to 11 should be in primary level: */
replace age_school=1 if (schage>=6&schage<=11) 
/*6. Assigning value for LS: For lower secondary education, assign 2 to official age bracket for lower secondary level. 
In Sierra Leone this means all children of age 12 to 14 should be in primary level: */
replace age_school=2 if (schage>=12&schage<=14) 
 /*7. Assigning value for US: For upper secondary education, assign 3 to official age bracket for upper secondary level. 
In Sierra Leone this means all children of age 15 to 18 should be in primary level: */
replace age_school=3 if (schage>=15&schage<=18)
/*8. Defining and associating value labels with the new variable 'age_school'. Define the label by creating 3 value label that associates
1 with Primary, 2 with Lower Secondary and 3 with upper secondary*/
lab def lab_age_sch  1 "Primary" 2 "Lower secondary" 3 "Upper secondary" 
lab val age_school lab_age_sch /*Associates the variable 'age_school' generated in line 20 with the value labels defined in line 32.*/
*********
/*9. Generate 3 other variables useful for analysis: 
age which is equal to HL6(age). By creating new variable, we ensure the input for HL6 is maintained. and if any change has to be made to the data, we can do so with 'age' var
age2 this is age*age, and is useful to run regressions
schage2 this is schae*schage. Schage is a variable calculated in MICS for all datasets. It is not calculated in other household surveys. */
gen age=HL6
gen age2=HL6*HL6
gen schage2=schage*schage
preserve /*The preserve command here saves a temporary copy of the HL dataset that we can later revert to using the restore command */
*********Preparing women questionnaire
use wm,clear
/*10. only keeping completed questionnaires*/
keep if WM17==1 
/*11. Renaming to match variable name in HL dataset. In HL, line number is 'HL1' whereas in men and women's
questionnaire it is 'LN'  */
ren LN HL1
/*12. Only keeping relevant variables in the questionnaire. You can explore each variable using 'describe' command */
keep HH1 HH2 HL1 WB14 WAGEM MT6* MT4 MT5 welevel wmweight MA1 MA5
/*13. Sorting according to cluster, household and line number to systematically merge this dataset with HL dataset later */ 
sort HH1 HH2 HL1
/*14.Saving women dataset with the changes on renaming and dropping variable as well as sorted dataset  */
save women,replace
/*15. The command 'restore' here brings back HL dataset as it was in line 38, before the wm dataset was used*/
restore
/*16. Again use the combination of preserve and restore to save a temporary copy of HL dataset while making changed to the men's dataset */
preserve 
************Preparing men's questionnaire: The same steps as women's questionnaire to be performed here as well 
use mn,clear
/*17. only keeping completed questionnaires*/
keep if MWM17==1 
/*18. Renaming to match variable name in HL dataset. In HL, line number is 'HL1' whereas in men and women's
questionnaire it is 'LN'  */
ren LN HL1
/*19. Only keeping relevant  in the questionnaire. You can explore each variable using 'describe' command */
keep HH1 HH2 HL1 MWB14 MWAGEM MMT6* MMT4 MMT5 mwelevel mnweight MMA1 MMA5
/*20. Sorting according to cluster, household and line number to systematically merge this dataset with HL dataset latee */ 
sort HH1 HH2 HL1
/*21.Saving women dataset with the changes on renaming and dropping variable as well as sorted dataset */
save men, replace
/*22. The command 'restore' here brings back HL dataset as it was in line 38, before the mn dataset was used*/
restore
/*23. Sorting the HL questionnaire according to cluster, household and liine number, same as women and men's questionnaire */
sort HH1 HH2 HL1
/*24. Joining corresponding observations in HL with those in the men's questionnaire*/
merge HH1 HH2 HL1 using men
/*25. Merge creates a new variable '_m' by default which for each observation shows the result of merging ie. 'merged result for each observation'. */
tab _m
/*26. Remove '_m' variable since it is not needed */
drop _m
/*27. Sort the HL dataset again to prepare for merging with omen's questionnaire */
sort HH1 HH2 HL1
/*28. Joining corresponding observations in HL with those in the women's questionnaire*/ 
merge HH1 HH2 HL1 using women
/*The HL dataset now contains our HL variables upto line 38, and the additional merged variables from men and women's questionnaire:
Men's questionnaire variables added: MWB14, MWAGEM, MMT6*, MMT4, MMT5, mwelevel, mnweight, MMA1, MMA5
Women's questionnaire variables added:WB14, WAGEM, MT6*, MT4, MT5, welevel, wmweight, MA1, MA5*/ 
/*29. WB14 and MEB14 contain information on whether the man or woman was able to read
a part of the sentence. Here we make sure all observations are filled in WB14*/
replace WB14=MWB14 if WB14==.
/*30. Delete the '_m' variable remaining from merging the women and HL questionnaire    */ 
drop _m
/*31. Erase the men and women's questionnaire from memory */
erase men.dta
erase women.dta
/*32. Ensure equivalence in weights since the data is merged from different questionnaires*/
gen nweight=mnweight
replace nweight=wmweight if nweight==.
****************** Calculating literacy
/*33. Generate a new variable for all observation*/
gen literate=.
/*34. Replace the value for literate using MWB14 and WB14:
MWB14==1|WB14==1 represents cannot read at all
MWB14==2|WB14==2 represents able to read only parts of the sentence.
Therefore literate=0 represents those who are not literate*/
replace literate=0 if MWB14==1|MWB14==2|WB14==1|WB14==2
/*35.  Replace the value for literate using MWB14 and WB14:
MWB14==3|WB14==3 represents able to read complete sentence
(m)welevel>=2&(m)welevel<=5 represents at least attaining lower secondary education.
Therefore literate=1 represents those who are literate  */
replace literate=1 if MWB14==3|WB14==3
replace literate=1 if welevel>=2&welevel<=5
replace literate=1 if mwelevel>=2&mwelevel<=5

/*36. Save the merged dataset as 'COUNTRY_ready */
save SL_ready,replace


***************Prepare another dataset using HL from different years for historical analysis of ANAR
/*1. Please make sure to download HL datasets from all previous years, here we are using SL dataset from
 2017 (saved as hl);
 2010 (saved as hl_2010);
 2005 (saved as hl_2005); 
 2000 (saved as hl_2000). 
 */
**Merge all years
/*1. Use current year HL dataset*/
use hl,clear
/*2. Generate a new variable year for all observations */
gen year=2017
/*3. Append using hl_2010. Appedning file means adding the 2007 HL file to the current HL file  */
ap using hl_2010
/*4. Since we had already specified year=2017 for HL files, the empty year cells belong to
2010 dataset. Use the replace command to signify this */
replace year=2010 if year==.
/*5. Names of variables and label values may differ between survey rounds,
harmonize variable names and label values accoding to HL in 2017. 
For ANAR, the relevant changes to be made are for datapoints from 2010 and are: 
a. use ED6A and ED6B to correctly calculate "ED10A" for 2010 data points to signify education level
at the time of interview
b. ED5 from 2010 represents ED9 from 2017 [Attended school during current school year]. */
replace ED9=ED5 if year==2010
replace ED10A=ED6A if year==2010
replace ED10A=4 if ED6A==3&year==2010
replace ED10A=2 if ED6A==2&(ED6B>=1&ED6B<=3)&year==2010
replace ED10A=3 if ED6A==2&(ED6B>=4&ED6B<=6)&year==2010
/*6. Now, append the 2005 dataset to this dataset which already contains 2017 and 2010 values. */
ap using hl_2005
/*7. Similar to what we did in step 4 above, the empty year cells now belong to data points
from 2005. Use the replace command to signify this*/
replace year=2005 if year==.
/*8. Names of variables and label values may differ between survey rounds,
harmonize variable names and label values accoding to HL in 2017. 
For ANAR, the relevant changes to be made are for datapoints from 2005 and are: 
a. use ED6A and ED6B to correctly calculate "ED10A" for 2005 data points to signify education level
at the time of interview
b. ED4 from 2005 represents ED9 from 2017 [Attended school during current school year].
c. Calculate schage which is age-1 */
replace ED9=ED4 if year==2005
replace ED10A=ED6A if year==2005
replace ED10A=4 if ED6A==3&year==2005
replace ED10A=2 if ED6A==2&(ED6B>=1&ED6B<=3)&year==2005
replace ED10A=3 if ED6A==2&(ED6B>=4&ED6B<=6)&year==2005
replace schage=HL5-1 if year==2005
/*9. Append the 2000 dataset to this dataset which already contains 2017, 2010 and 2005 values.*/
ap using hl_2000
/*7. Similar to what we did in step 4 and 7 above, the empty year cells now belong to data points
from 2000. Use the replace command to signify this*/
replace year=2000 if year==.
/*8. Names of variables and label values may differ between survey rounds,
harmonize variable names and label values accoding to HL in 2017. 
For ANAR, the relevant changes to be made are for datapoints from 2000 and are: 
a. use ed20a and ed20b to correctly calculate "ED10A" for 2000 data points to signify education level
at the time of interview
b. ed17 from 2000 represents ED9 from 2017 [Attended school during current school year].
c. Calculate schage which is age-1 */
replace ED9=ed17 if year==2000
replace ED10A=ed20a-1 if year==2000
replace ED10A=4 if ed20a==4&year==2000
replace ED10A=2 if ed20a==3&(ed20b>=1&ed20b<=3)&year==2000
replace ED10A=3 if ed20a==3&(ed20b>=4&ed20b<=6)&year==2000
replace schage=hl4-2 if year==2000
/*9. Generate a new variable total to account for all observations in the appended dataset  */
gen total=1
/*10. Create a new variable to group children according to official age brackets for each level of education  */
gen age_school=. 
/*11.  Assigning value for Pre-primary education: For pre-primary education, assign 0 to official age bracket for primary level. 
In Sierra Leone this means all children of age 5 should be pre-primary level: */
replace age_school=0 if schage==5
/*12.  Assigning value for primary education: For primary education, assign 1 to official age bracket for primary level. 
In Sierra Leone this means all children of age 6 to 11 should be in primary level: */
replace age_school=1 if (schage>=6&schage<=11)
/*13.  Assigning value for lower secondary education: For lower secondary education, assign 2 to official age bracket for ls level. 
In Sierra Leone this means all children of age 12 to 14 should be in lower secondary level: */
replace age_school=2 if (schage>=12&schage<=14)
/*14.  Assigning value for upper secondary education: For upper secondary education, assign 3 to official age bracket for us level. 
In Sierra Leone this means all children of age 15 to 18 should be in upper secondary level: */
replace age_school=3 if (schage>=15&schage<=18)
/*15.Generate a new variable attendance to calculate attendance for each level */
gen attendance=0 if age_school!=.
/*16.For pre-primary (Please note that across years:
ED10A==0 denotes pre-primary attendance
ED10A==1 denotes primary attendance
xED10A==2 denotes lower secondary attendance
ED10A==3 denotes upper secondary attendance
ED10A==4 denotes vocational education
ED10A==5 denotes university education and beyond */
replace attendance=1 if age_school==0&ED9==1&(ED10A==1|ED10A==0) 
replace attendance=1 if age_school==1&ED9==1&(ED10A==1|ED10A==2) 
replace attendance=1 if age_school==2&ED9==1&(ED10A==2|ED10A==3) 
replace attendance=1 if age_school==3&ED9==1&(ED10A==3|ED10A==4|ED10A==5)
/*17. Only keep relevant variables for analysis */
keep year ED9 ED10A age_scho atten total hhweight
/*18. Save this new appended dataset with information from 2000, 2005, 2010, and 2017 for SL */
save hl_SL_hist,replace




/* Preparing 5 to 17 questionnaire*/
/*1.Using the dataset for questionnaire for 5 to 17. For this dataset, we are calculating some additional variables
that can be used for tabulations later */
use fs,clear
gen total=1
*****************Child disciplining
/*2. Genereate a variable for exposure to any kind of violent disciplining: physical, socioemotional, severe.
Use the 'des FCD2A FCD2B FCD2C FCD2D FCD2F FCD2G FCD2H FCD2I FCD2J FCD2K' command to explore the variables  */
gen anyviolent=0
replace anyviolent=1 if FCD2C==1|FCD2D==1|FCD2F==1|FCD2G==1|FCD2H==1|FCD2I==1|FCD2J==1|FCD2K==1
/*3. Generate a variable for ONLY nonviolent disciplining */
gen onlynonviolent=0
replace onlynonviolent=1 if anyvio==0&(FCD2A==1|FCD2B==1|FCD2E==1)
/*4. Generate a variable for socioemotional violent disciplining   */
gen psycho=0
replace psycho=1 if FCD2D==1|FCD2H==1
/*5. Generate a variable for physical disciplining, which includes severe punishment*/
gen physical=0
replace physical=1 if FCD2C==1|FCD2F==1|FCD2G==1|FCD2I==1|FCD2J==1|FCD2K==1
/*6. Generate a variable for severe disciplining  */
gen severe=0
replace severe=1 if FCD2I==1|FCD2K==1
/*7. Generare a variable for nonviolent disciplining   */
gen nonviolent=0
replace nonviolent=1 if FCD2A==1|FCD2B==1|FCD2E==1

****attendance
/*8. Generate a new variable to count for attendance in school  */
gen attendance=1 if CB7==1
replace attendance=0 if CB7==2|CB4==2
** years of education
/*9.Create a variable to count for number of years in school.
CB4==2 shows that child never attended ECE or primary school. There 0 years of schooling
CB5A shows the highest level attended and CB5B shows the highest grade at that level*/
gen years_educ=0 if CB4==2
replace years=CB5B if CB5A==1
replace years=CB5B+6 if CB5A==2
replace years=CB5B+9 if CB5A==3
replace years=CB5B+13 if CB5A==5

****Language of instruction by teacher
/*10. Use the 'tab FL9', and 'tab FL9, nol' for the primary language of instruction in class.
Generate a new variable if the primary language differs from the common language in the country
spoken at home*/ 
gen english=1 if FL9==1
replace english=0 if FL9==7
/*11. Save the dataset*/
save SL_fs_ready,replace
