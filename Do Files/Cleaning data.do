
* Cleaning MP2 dataset

* Author: 			Flo Martin

* Date started: 	08/02/2021
* Date finished: 

cd "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis"
use mp2.dta, clear

* As we're investigating maternal exposures & outcomes, we don't need qlet = B otherwise mum's of multiple pregnancies will be counted twice
drop if qlet == "B"

* Renaming some of the variables for ease of analysis (not all as some will be used to generate new vars) - "sr" means self-report "del" means delivery "bw" means birthweight
rename kz011b alive_1yr
rename kz021 sex
rename kz030 bw
rename kz033 placenta_wt_path
rename kz033a placenta_wt_obstetric
rename v1dab6k_diabetes preg_diabetes_oa
rename v1dae3a1_weight_placenta placenta_wt_oa
rename DEL_B3000 placenta_weighed_oc
rename DEL_B3001 placenta_weight_oc
rename DEL_B3002 placenta_abnorm_oc
rename mz024b year_del
rename mz028b matage_del
rename dw042 mat_bmi
rename d041 preg_diabetes_sr
rename d046 hyp_history
rename d168 alcoholism_history
rename a525 marital_status
rename b032 parity
rename c645a mat_edu
rename d168a alcoholism_bin

* Using Luisa's script for generating variables to describe drinking patterns (exposure)
* total weekly drinking before pregnancy (q.aire b - recall) 
* 4 levels variable including never drinkers
tab b720, m
g byte alc4_before=1 if b720==1
replace alc4_before=2 if b720==2
replace alc4_before=3 if b720==3
replace alc4_before=4 if b720>3 & b720~=-1 & b720~=.
label variable alc4_before "total weekly drinking before pregnancy (q.aire b - recall)"
label define alc4  1 "Never" 2 "<1 glass/wk" 3 "1+ glasses/wk" 4 "7+ glasses/wk"
label values alc4_before alc4
tab b720 alc4_before, miss

* total weekly drinking in 1st trimester of pregnancy (q.aire b - recall) 
* 4 levels variable including never drinkers
tab b721, m
g byte alc4_tri=1 if b721==1
replace alc4_tri=2 if b721==2
replace alc4_tri=3 if b721==3
replace alc4_tri=4 if b721>3 & b721~=-1 & b721~=.
label variable alc4_tri "total weekly drinking during 1st trimester (q.aire b - recall)"
label values alc4_tri alc4
tab b721 alc4_tri, miss

* total weekly drinking in 2nd trimester of pregnancy (q.aire b - cross sectional) 
* 4 levels variable including never drinkers
tab b722, m
g byte alc4_18w=1 if b722==1
replace alc4_18w=2 if b722==2
replace alc4_18w=3 if b722==3
replace alc4_18w=4 if b722>3 & b722~=-1 & b722~=.
label variable alc4_18w "total weekly drinking during 2nd trimester (q.aire b - cross-sectional)"
label values alc4_18w alc4
tab b722 alc4_18w, miss

* total weekly drinking in 3rd trimester of pregnancy (q.aire e - recall) 
* 4 levels variable including never drinkers
tab e220, m
g byte alc4_last2=1 if e220==1
replace alc4_last2=2 if e220==2
replace alc4_last2=3 if e220==3
replace alc4_last2=4 if e220>3 & e220~=-1 & e220~=.
label variable alc4_last2 "total weekly drinking in last 2 months of pregnancy (q.aire e - recall)"
label values alc4_last2 alc4
tab e220 alc4_last2, mis

* total weekly drinking in 1st trimester (q.aire a, could also be much later!!) (adding up alcohol from wine, beer, spirits and other)
qui foreach v of var a252-a260 { 
	replace `v'=. if `v'<0
} 
gen alcXweek_8w = . 
qui foreach v of var a252-a260 { 
	replace alcXweek_8w = cond(missing(alcXweek_8w), `v', alcXweek_8w + `v') if !missing(`v') & b721~=. & b721~=-1
} 
tab alcXweek_8w, m
tab b721 if alcXweek_8w==0, m  /* this shows that deriving weekly drinking in this could UNDERESTIMATE alc intake */
bysort b721: summ alcX
*hist alcX if b721~=. & b721>=0, by(b721)	/* oh dear, cross-checking these two vars we see a lot of inconsistencies.... */
g diff=alcXweek_8w-a261 if b721~=. & b721>=0
*hist diff		/*  does the var a261 take into account observations where one of the alc types was missing? probably not!   */
drop diff

* cleaning alc drinking at 8 wks based on dual info from b721 and alcXweek_tri
* basic principle: cannot be non-drinker if reports drinking in the other var, but don't change b721 for consistency with b722 and b720
replace alcXweek_8w=. if alcXweek_8w==0 & b721>=5 & a902<=14  /* only for women completing this q.aire in first trimester, ie gestweek<14 */

* total weekly drinking in 2nd trimester (around 18wk gestation) (adding up alcohol from wine, beer, spirits and other)
qui foreach v of var b754 b757 b760 b769 { 
	replace `v'=. if `v'<0
} 
gen alcXweek_18w = . 
qui foreach v of var b754 b757 b760 b769 { 
	replace alcXweek_18w = cond(missing(alcXweek_18w), `v', alcXweek_18w + `v') if !missing(`v') & b722~=. & b722~=-1
} 
tab alcXweek_18w, m
tab b722 if alcXweek_18w==0, m  /* this shows that deriving weekly drinking in this could UNDERESTIMATE alc intake */
bysort b722: summ alcXweek_18w
*hist alcXweek_18w if b722~=. & b722>=0, by(b722)	/* oh dear, cross-checking these two vars we see a lot of inconsistencies.... */

* cleaning alc drinking at 18 wks based on dual info from b722 and alcXweek
* basic principle: cannot be non-drinker if reports drinking in the other var, but don't change b722 for consistency with b721 and b720
replace alcXweek_18w=. if alcXweek_18w==0 & b722>=5 &  b924>=14 &  b924<=27 /* only for women completing this q.aire in third trimester, ie 14<=gestweek<=27 */

* total weekly drinking in 3rd trimester (around 32wk gestation) (adding up alcohol from wine, beer, spirits and other)
qui foreach v of var c363 c366 c369 c372 { 
	replace `v'=. if `v'<0
} 
gen alcXweek_32w = . 
qui foreach v of var c363 c366 c369 c372 { 
	replace alcXweek_32w = cond(missing(alcXweek_32w), `v', alcXweek_32w + `v') if !missing(`v') 
} 
tab alcXweek_32w, m
tab e220 if alcXweek_32w==0, m  /* this shows that deriving weekly drinking in this could UNDERESTIMATE alc intake */
bysort e220: summ alcXweek_32w
*hist alcXweek_32w if e220~=. & e220>=0, by(e220)	/* oh dear, cross-checking these two vars we see a lot of inconsistencies.... */

* cleaning alc drinking at 32 wks based on dual info from e220 and alcXweek
* basic principle: cannot be non-drinker if reports drinking in the other var, but don't change e220 for consistency with b721 and b720
replace alcXweek_32w=. if alcXweek_32w==0 & e220>=5 & c991>=27 & c991~=. /* only for women completing this q.aire in third trimester, ie 27<=gestweek<=42 */

* bingeing during pregnancy (q.aire b) - 18 weeks
tab b723, miss
g byte bingeduring_18w=1 if b723>=1 & b723>=0 & b723~=.
replace bingeduring_18w=0 if bingeduring_18w==. & b723==0
tab b723 bingeduring_18w, miss
label var bingeduring_18w "Consuming 4+ drinks in second trimester of pregnancy"
* bingeing during pregnancy (q.aire c) - 32 weeks
tab c360, miss
g byte bingeduring_32w=1 if c360>=1 & c360>=0 & c360~=.
replace bingeduring_32w=0 if bingeduring_32w==. & c360==0
tab c360 bingeduring_32w, miss
label var bingeduring_32w "Consuming 4+ drinks in third trimester of pregnancy"

* bingeing during pregnancy at either week 18 or 32, Vs not bingeing 
g byte bingeduring_preg=1 if bingeduring_18w==1 | bingeduring_32w==1
replace bingeduring_preg=0 if bingeduring_18w==0 & bingeduring_32w==0
tab bingeduring_preg bingeduring_18w , miss
tab bingeduring_preg bingeduring_32w , miss
label var bingeduring_preg "Consuming 4+ drinks in second and/or third trimester of pregnancy"


* high/low alc defined as above/below reccommended alc intake threshold at the time - 1st trim
g byte alc2_tri=1 if alc4_tri<=2
replace alc2_tri=2 if alc4_tri>2 & alc4_tri~=.
label var alc2_tri "Binary var for alcohol consumption in 1st trim"
label define highlow 1 "Low - <1 drink/w" 2 "High - 1+ drink/w"
label values alc2_tri highlow
tab alc4_tri alc2_tri, m

* high/low alc defined as above/below reccommended alc intake threshold at the time - 2nd trim
g byte alc2_18w=1 if alc4_18w<=2
replace alc2_18w=2 if alc4_18w>2 & alc4_18w~=.
label var alc2_18w "Binary var for alcohol consumption in 2nd trim"
label values alc2_18w highlow
tab alc4_18w alc2_18w, m

* high/low alc defined as above/below reccommended alc intake threshold at the time - 3rd trim
g byte alc2_last2=1 if alc4_last2<=2
replace alc2_last2=2 if alc4_last2>2 & alc4_last2~=.
label var alc2_last2 "Binary var for alcohol consumption in 3rd trim"
label values alc2_last2 highlow
tab alc4_last2 alc2_last2, m

* drinking yes Vs no before pregnancy
g byte abstain_before=1 if b720==1
replace abstain_before=0 if b720>1 & b720~=.
tab b720 abstain_before, miss
label var abstain_before "Abstaining from alcohol before pregnancy"

* drinking yes Vs no in first trimester 
*( exclude from abstainers those mums reporting alc consumption in detailed q.s from a q.aire )
g byte abstain_tri=1 if b721==1 & (((alcXweek_8w==0 | alcXweek_8w==.) & a902<=14 ) |  a902>14)
replace abstain_tri=0 if abstain_tri==. & b721~=-1 & b721~=.
tab b721 abstain_tri, miss
label var abstain_tri "Abstaining from alcohol in first trimester"

* drinking yes Vs no in second trimester (week 18) 
*( exclude from abstainers those mums reporting alc consumption in detailed q.s from b q.aire, and those bingeing )
g byte abstain_18w=1 if b722==1 & (((alcXweek_18==0 | alcXweek_18==.) &  b924>=14 &  b924<=27) | (b924<14 |  b924>27))
replace abstain_18w=0 if abstain_18w==1 & bingeduring_18w==1
replace abstain_18w=0 if abstain_18==. & b722~=. & b722~=-1 
tab b722 abstain_18w, miss
label var abstain_18w "Abstaining from alcohol in second trimester"


* drinking yes Vs no in third trimester (week 32 and last 2 months from e q.aire) 
*( exclude from abstainers those mums reporting alc consumption in detailed q.s from c q.aire, and binge drinkers )
g byte abstain_last2=1 if e220==1 & (((alcXweek_32w==0 | alcXweek_32w==.) & c991>=27 & c991~=.) | (c991<27 | c991==.))
replace abstain_last2=0 if abstain_last2==1 & bingeduring_32w==1
replace abstain_last2=0 if abstain_last2==. & e220~=. & e220~=-1 
tab e220 abstain_last2, miss
label var abstain_last2 "Abstaining from alcohol in third trimester"

* drinking at any point before or during pregnancy - abstaining before and during
g byte abstain_preg=1 if abstain_before==1 & abstain_tri==1 & abstain_18w==1 & abstain_last2==1
replace abstain_preg=0 if abstain_before==0 | abstain_tri==0 | abstain_18w==0 | abstain_last2==0
label variable abstain_preg "Abstaining before and during pregnancy"
label define yesno 0"No" 1"Yes"
label values abstain_preg yesno
tab abstain_preg, m

* abstaining since very early on in pregnancy (around preg recognition), not before - week 8
* (abstaining from week 8 but not before preg, and then again in first and second and third trimester )
g byte abstain_duringonly=1 if abstain_before==0 & abstain_tri==1 & abstain_18w==1 & abstain_last2==1
replace abstain_duringonly=0 if abstain_before==0 & (abstain_tri==0 | abstain_18w==0 | abstain_last2==0)
label variable abstain_duringonly "Abstaining during pregnancy (not before)"
label values abstain_duringonly yesno
tab abstain_duringonly abstain_preg, m
tab abstain_duringonly 

* Cleaning & generating outcome variables
* Hypertensive disorders of pregnancy (HDP) from OA documentation
tab HDP
tab prev_hyp
tab preeclampsia
tab sup_preeclampsia preeclampsia
tab gesthyp

* Gestational diabetes
tab preg_diabetes_oa
replace preg_diabetes_oa = 0 if preg_diabetes_oa ==2
label define bin_lb 1"Yes" 0"No"
label values preg_diabetes_oa bin_lb
tab preg_diabetes_oa

tab pregnancy_diabetes, nolabel

tab preg_diabetes_sr
replace preg_diabetes_sr =. if preg_diabetes_sr == -2 | preg_diabetes_sr == -1
replace preg_diabetes_sr = 0 if preg_diabetes_sr == 2
label values preg_diabetes_sr bin_lb
tab preg_diabetes_sr

* Says in the documentation that the obstetric data is not recommended due to variable measures
tab placenta_wt_obstetric, nolabel
replace placenta_wt_obstetric =. if placenta_wt_obstetric == -1 | placenta_wt_obstetric == -10
tab placenta_wt_obstetric

tab placenta_wt_path
replace placenta_wt_path =. if placenta_wt_path == -1 | placenta_wt_path == -10
tab placenta_wt_path

* n = 13 with weights from both path and obstetric (path under obstetric in all)
tab placenta_wt_obstetric placenta_wt_path
list placenta_wt_obstetric placenta_wt_path if placenta_wt_obstetric !=. & placenta_wt_path !=.

tab Placenta_Weight, nolabel
replace Placenta_Weight =. if Placenta_Weight == -2 | Placenta_Weight == -1
tab Placenta_Weight

* Combining the Path study (placenta_wt_path) and the Barker study (Placenta_Weight)
replace placenta_weight = placenta_wt_path if placenta_wt_path >0
replace placenta_weight = Placenta_Weight if placenta_wt_path ==.
tab placenta_weight

* Generate placenta weight:birthweight ratio
tab bw, nolabel
replace bw =. if bw == -1 | bw == -10
generate pw_bw_ratio = bw/placenta_weight
tab pw_bw_ratio
* n = 40 missing birthweight
list placenta_weight bw pw_bw_ratio if bw ==. & placenta_weight !=.
* One ratio of 54.24 outlier remove it
replace pw_bw_ratio =. if pw_bw_ratio >20 
histogram pw_bw_ratio

generate log_pwbw = log(pw_bw_ratio)
list pw_bw_ratio log_pwbw

zscore log_pwbw bestgest
list pw_bw_ratio log_pwbw z_log_pwbw

tab bestgest
scatter z_log_pwbw bestgest if bestgest >24

fp <bestgest>: regress z_log_pwbw <bestgest>

* Covariates
* Maternal age at delivery
tab matage_del, nolabel
replace matage_del =. if matage_del == -10 | matage_del == -4 | matage_del == -2

* Year of delivery
tab year_del, nolabel
replace year_del =. if year_del == -2 | year_del == -1

* Maternal BMI
tab mat_bmi, nolabel
replace mat_bmi =. if mat_bmi == -3

* Maternal education
tab mat_edu, nolabel
replace mat_edu =. if mat_edu == -1

* History of hypertension (obstetric data)
tab prev_hyp

* History of alcoholism (self-report)
tab alcoholism_history
replace alcoholism_history =. if alcoholism_history == -1

* Maternal marital status
tab marital_status, nolabel
replace marital_status =. if marital_status == -1

* Prenatal smoking
* Number of cigarettes in the first trimester (up to end of 12 weeks)
* b721 asks for number smoked in last two weeks, which could be first trimester depending in when the questionnaire was filled out
tab b670, nolabel
replace b670 =. if b670 == -1
tab b671, nolabel
replace b671 =. if b671 == -1
tab b924, nolabel
replace b924 =. if b924 == -1
generate smoking_mother_firsttrim_ordinal =.
replace smoking_mother_firsttrim_ordinal =. if b670 ==.
replace smoking_mother_firsttrim_ordinal = 0 if b670 ==0 | (b671 ==0 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 1 if b670 ==1 | (b671 ==1 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 1 if b670 ==5 | (b671 ==5 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 2 if b670 ==10 | (b671 ==10 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 2 if b670 ==15 | (b671 ==15 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 3 if b670 ==20 | (b671 ==20 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 3 if b670 ==25 | (b671 ==25 & b924 <=12)
replace smoking_mother_firsttrim_ordinal = 3 if b670 ==30 | (b671 ==30 & b924 <=12)
label define smoking_firsttrim_ordinal_lb 0"None" 1"Light" 2"Moderate" 3"Heavy"
label values smoking_mother_firsttrim_ordinal smoking_firsttrim_ordinal_lb
tab smoking_mother_firsttrim_ordinal

generate smoking_t1 =.
replace smoking_t1 = 0 if smoking_mother_firsttrim_ordinal == 0
replace smoking_t1 = 1 if smoking_mother_firsttrim_ordinal == 1 | smoking_mother_firsttrim_ordinal == 2 | smoking_mother_firsttrim_ordinal == 3
label values smoking_t1 bin_lb
tab smoking_t1

* Number of cigarettes in the second trimester (13 to 26 weeks)
* b721 asks for number smoked in last two weeks, which is second trimester depending in when the questionnaire was filled out & fill in gaps with c482
tab c482
replace c482 =. if c482 == -7 | c482 == -1 | c482 ==.
replace c482 = 1 if c482 == 1 | c482 == 2 | c482 == 3 | c482 == 4
replace c482 = 5 if c482 == 5 | c482 == 6 | c482 == 7 | c482 == 8 | c482 == 9
replace c482 = 10 if c482 == 10 | c482 == 11 | c482 == 12 | c482 == 13 | c482 == 14
replace c482 = 15 if c482 == 15 | c482 == 16 | c482 == 17 | c482 == 18 | c482 == 19
replace c482 = 20 if c482 == 20 | c482 == 21 | c482 == 22 | c482 == 23 | c482 == 24
replace c482 = 25 if c482 == 25 | c482 == 26 | c482 == 27 | c482 == 28 | c482 == 29
replace c482 = 30 if c482 >= 30 & c482 <=60
tab c482, nolabel
generate smoking_secondtrim_ordinal =.
replace smoking_secondtrim_ordinal = 0 if (b671 ==0 & b924 >=13 & b924 <=26) | (c482 ==0 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 1 if (b671 ==1 & b924 >=13 & b924 <=26) | (c482 ==1 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 1 if (b671 ==5 & b924 >=13 & b924 <=26) | (c482 ==5 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 2 if (b671 ==10 & b924 >=13 & b924 <=26) | (c482 ==10 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 2 if (b671 ==15 & b924 >=13 & b924 <=26) | (c482 ==15 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==20 & b924 >=13 & b924 <=26) | (c482 ==20 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==25 & b924 >=13 & b924 <=26) | (c482 ==25 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==30 & b924 >=13 & b924 <=26) | (c482 ==30 & c991 >=13 & c991 <=26)
label values smoking_secondtrim_ordinal smoking_firsttrim_ordinal_lb
tab smoking_secondtrim_ordinal

generate smoking_t2 =.
replace smoking_t2 = 0 if smoking_secondtrim_ordinal == 0
replace smoking_t2 = 1 if smoking_secondtrim_ordinal == 1 | smoking_secondtrim_ordinal == 2 | smoking_secondtrim_ordinal == 3
label values smoking_t2 bin_lb
tab smoking_t2

* Number of cigarettes in the third trimester (27 weeks onwards)
* e178 asks for number smoked in last two months of pregnancy, then supplement missing with c482 if questionnaire filled out in third trimester & b671 if filled out in T3
tab e178, nolabel
replace e178 =. if e178 == -1

generate smoking_thirdtrim_ordinal =.
replace smoking_thirdtrim_ordinal = 0 if e178 ==0 
replace smoking_thirdtrim_ordinal = 1 if e178 ==1 
replace smoking_thirdtrim_ordinal = 1 if e178 ==5   
replace smoking_thirdtrim_ordinal = 2 if e178 ==10  
replace smoking_thirdtrim_ordinal = 2 if e178 ==15  
replace smoking_thirdtrim_ordinal = 3 if e178 ==20  
replace smoking_thirdtrim_ordinal = 3 if e178 ==25 
replace smoking_thirdtrim_ordinal = 3 if e178 ==30
label values smoking_thirdtrim_ordinal smoking_firsttrim_ordinal_lb
tab smoking_thirdtrim_ordinal

replace smoking_thirdtrim_ordinal = 0 if smoking_thirdtrim_ordinal ==. & c482 ==0 & c991 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & c482 ==1 & c991 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & c482 ==5 & c991 >=27  
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & c482 ==10 & c991 >=27 
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & c482 ==15 & c991 >=27  
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482 ==20 & c991 >=27
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482 ==25 & c991 >=27 
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482 ==30 & c991 >=27
tab smoking_thirdtrim_ordinal

replace smoking_thirdtrim_ordinal = 0 if smoking_thirdtrim_ordinal ==. & b671 ==0 & b924 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & b671 ==1 & b924 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & b671 ==5 & b924 >=27 
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & b671 ==10 & b924 >=27
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & b671 ==15 & b924 >=27  
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==20 & b924 >=27
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==25 & b924 >=27 
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==30 & b924 >=27
tab smoking_thirdtrim_ordinal, m

generate smoking_t3 =.
replace smoking_t3 = 0 if smoking_thirdtrim_ordinal == 0
replace smoking_t3 = 1 if smoking_thirdtrim_ordinal == 1 | smoking_thirdtrim_ordinal == 2 | smoking_thirdtrim_ordinal == 3
label values smoking_t3 bin_lb
tab smoking_t3

generate smoking_preg =.
replace smoking_preg = 0 if smoking_t1 ==0 & smoking_t2 ==0 & smoking_t3 ==0
replace smoking_preg = 1 if smoking_t1 ==1 | smoking_t2 ==1 | smoking_t3 ==1
label values smoking_preg bin_lb
tab smoking_preg

* History of hypertension
tab hyp_history
replace hyp_history =. if hyp_history == -1
replace hyp_history = 0 if hyp_history == 2
label values hyp_history bin_lb
tab hyp_history

* History of alcoholism
tab alcoholism_history
tab alcoholism_bin, nolabel
replace alcoholism_bin = 0 if alcoholism_bin ==2
label values alcoholism_bin bin_lb
tab alcoholism_bin

* Maternal education
tab mat_edu, nolabel
generate mat_degree =.
replace mat_degree = 0 if mat_edu <5
replace mat_degree = 1 if mat_edu ==5
label values mat_degree bin_lb 
tab mat_degree

* Marital status
tab marital_status, nolabel
generate married_bin =.
replace married_bin = 0 if marital_status <5
replace married_bin = 1 if marital_status >=5 & marital_status !=.
label values married_bin bin_lb
tab married_bin

save mp2_analysis.dta, replace
