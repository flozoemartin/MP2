
* Data cleaning of data extract (ALSPAC) from 08/02/2021 for mini project 2 - alcohol during pregnancy and HDP *

* Author: Flo Martin *

* Date started: 08/02/2021 *
* Date finished: 02/06/2021 *

* Contents *
* line 24 - Labels *
* line 55 - Exposure variables *
* line 328 - Outcome variables *
* line 341 - Confounder variables *
* line 535 - Saving clean dataset *
* line 537 - Sensitivity analysis variables *
* line 609 - Saving clean complete case dataset *

cd "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis"
use mp2.dta, clear

* As we're investigating maternal exposures & outcomes, we don't need qlet = B otherwise mum's of multiple pregnancies will be counted twice
drop if qlet == "B"

* Setting some general labels to use with new variables
label define bin_lb 0"No" 1"Yes"
label define amounts_lb 0"Never" 1"<1 glass per week" 2"1+ glasses per week" 3"7+ glasses per week"
label define weekly_lb 0"Never" 1"1+ glasses per week" 2"7+ glasses per week"
label define daily_lb 0"Never" 1"1-3 per day" 2"4+ per day"
label define cat_lb 0"None" 1"Low-to-moderate" 2"Heavy"
label define alcohol_preg_binge_lb 0"None" 1"LTM" 2"Heavy" 3"Bingeing"
label define smoking_lb 0"None" 1"Light" 2"Moderate" 3"Heavy"
label define mat_age_cat_lb 0"Under 25" 1 "25 and over"
label define parity_lb 0"Nulliparous" 1"Multiparous"
label define parity_cat_lb 0"Nulliparous" 3"3+"
label define ethn_lb 0"White" 1"Non-white"
label define bmi_cat_lb 0"Underweight" 1"Normal" 2"Overweight" 3"Obese"
label define hdp_cat_lb 0"Normotensive" 1"Gestational hypertension" 2"Preeclampsia"
label define beer_wine_lb 0"Beer" 1"Wine"
label define ltm_none_lb 0"None" 1"Low-to-moderate"
label define heavy_none_lb 0"None" 1"Heavy"
label define heavy_nonbinge_none_lb 0"None" 1"Heavy non-binge"
label define heavy_binge_none_lb 0"None" 1"Heavy binge"

* Renaming some of the variables for ease of analysis
rename mz028b matage_del
rename pa910 patage
rename dw042 mat_bmi
rename a525 marital_status
rename b032 parity
rename c645a mat_edu
rename pb325a pat_edu
rename c800 mat_ethn
rename pb440 pat_ethn

* Cleaning variables related to exposure (alcohol consumption during pregnancy)
* As per the meeting discussion on 24/02, answers from A and C questionnaires were deemed unreliable, thus we will build our exposed/unexposed cohort using B and E questionnaires

* These variables ask about specific types of drinks on typical week/weekend day (beer, wine, spirits)
foreach var of varlist b752-b760 {
	replace `var' =. if `var' <0
} 

* b752 asks about current beer drinking on a typical weekday
tab b752
generate b752_cat =.
replace b752_cat = 0 if b752 ==0
replace b752_cat = 1 if b752 >=1 & b752 <4
replace b752_cat = 2 if b752 >=4 & b752 !=.
label values b752_cat daily_lb
tab b752_cat

* b753 asks about current beer drinking on a typical weekend
tab b753
generate b753_cat =.
replace b753_cat = 0 if b753 ==0
replace b753_cat = 1 if b753 >=1 & b753 <4
replace b753_cat = 2 if b753 >=4 & b753 !=.
label values b753_cat daily_lb
tab b753_cat

* b754 is a derived variable of total weekly beer
tab b754
generate b754_cat =.
replace b754_cat = 0 if b754 ==0 
replace b754_cat = 1 if b754 >=1 & b754 <7 
replace b754_cat = 2 if b754 >=7 & b754 !=. 
tab b754_cat
label values b754_cat weekly_lb
tab b754_cat

* b755 asks about current wine drinking on a typical weekday
tab b755
generate b755_cat =.
replace b755_cat = 0 if b755 ==0
replace b755_cat = 1 if b755 >=1 & b755 <4
replace b755_cat = 2 if b755 >=4 & b755 !=.
label values b755_cat daily_lb
tab b755_cat

* b756 asks about current wine drinking on a typical weekend
tab b756
generate b756_cat =.
replace b756_cat = 0 if b756 ==0
replace b756_cat = 1 if b756 >=1 & b756 <4
replace b756_cat = 2 if b756 >=4 & b756 !=.
label values b756_cat daily_lb
tab b756_cat

* b757 is a derived variable of total weekly wine at present
tab b757
generate b757_cat =.
replace b757_cat = 0 if b757 ==0 
replace b757_cat = 1 if b757 >=1 & b757 <7 
replace b757_cat = 2 if b757 >=7 & b757 !=. 
tab b757_cat
label values b757_cat weekly_lb
tab b757_cat

* b758 asks about current spirits drinking on a typical weekday
tab b758
generate b758_cat =.
replace b758_cat = 0 if b758 ==0
replace b758_cat = 1 if b758 >=1 & b758 <4
replace b758_cat = 2 if b758 >=4 & b758 !=.
label values b758_cat daily_lb
tab b758_cat

* b759 asks about current spirits drinking on a typical weekend
tab b759
generate b759_cat =.
replace b759_cat = 0 if b759 ==0
replace b759_cat = 1 if b759 >=1 & b759 <4
replace b759_cat = 2 if b759 >=4 & b759 !=.
label values b759_cat daily_lb
tab b759_cat

* b760 is a derived variable of total weekly spirits at present
tab b760
generate b760_cat =.
replace b760_cat = 0 if b760 ==0 
replace b760_cat = 1 if b760 >=1 & b760 <7 
replace b760_cat = 2 if b760 >=7 & b760 !=.
tab b760_cat
label values b760_cat weekly_lb
tab b760_cat

* Binary spirits consumption
gen spirits_bin =.
replace spirits_bin = 1 if b760 >0
replace spirits_bin = 0 if b670 ==0
label values spirits_bin bin_lb
tab spirits_bin

* These variables ask about "other" drinks on typical week/weekend day
foreach var of varlist b767-b769 {
	replace `var' =. if `var' <0
}

* b767 asks about current other alcohol drinking on a typical weekday
tab b767
generate b767_cat =.
replace b767_cat = 0 if b767 ==0
replace b767_cat = 1 if b767 >=1 & b767 <4
replace b767_cat = 2 if b767 >=4 & b767 !=.
label values b767_cat daily_lb
tab b767_cat

* b768 asks about current other alcohol drinking on a typical weekend
tab b768
generate b768_cat =.
replace b768_cat = 0 if b768 ==0
replace b768_cat = 1 if b768 >=1 & b768 <4
replace b768_cat = 2 if b768 >=4 & b768 !=.
label values b768_cat daily_lb
tab b768_cat

* b769 is derived variable of total other alcohol at present
tab b769
generate b769_cat =.
replace b769_cat = 0 if b769 ==0 
replace b769_cat = 1 if b769 >=1 & b769 <7 
replace b769_cat = 2 if b769 >=7 & b769 !=. 
tab b769_cat
label values b769_cat weekly_lb
tab b769_cat

* Binary "other" alcohol consumption
gen other_bin =.
replace other_bin = 1 if b769 >0
replace other_bin = 0 if b769 ==0
label values other_bin bin_lb
tab other_bin

* Binary drinking anything other than beer & wine (sensitivity analysis variable to compare any other alcohol consumption in beer & wine drinkers)
gen extra_drinking =.
replace extra_drinking = 1 if other_bin ==1 | spirits_bin ==1
replace extra_drinking = 0 if other_bin ==0 & spirits_bin ==0
label values extra_drinking bin_lb
tab extra_drinking

* b721 asks about alcohol consumption in the first three months of pregnancy
tab b721, nolabel
replace b721 =. if b721 ==-1
replace b721 = 5 if b721 ==6
gen b721_cat =0 if b721 ==1
replace b721_cat =1 if b721 ==2
replace b721_cat =2 if b721 ==3
replace b721_cat =3 if b721 >=4 & b721 !=.
tab b721_cat
label values b721_cat amounts_lb

* b722 asks about alcohol consumption at around the time when the baby first moved (happens around 16 weeks)
tab b722, nolabel
replace b722 =. if b722 ==-1
replace b722 = 5 if b722 ==6
gen b722_cat =0 if b722 ==1
replace b722_cat =1 if b722 ==2
replace b722_cat =2 if b722 ==3
replace b722_cat =3 if b722 >=4 & b722 !=.
tab b722_cat
label values b722_cat amounts_lb
tab b722_cat

* b723 asks in the last month, how many times have you drank more than 4 beers/wines/spirits
tab b723, nolabel
replace b723 =. if b723 ==-1
replace b723 = 4 if b723 ==5
gen b723_bin =.
replace b723_bin = 0 if b723 ==0
replace b723_bin = 1 if b723 >0 & b723 !=.
label values b723_bin bin_lb
tab b723_bin

* Categorical drinking in the B questionnaire: none (0), low-to-moderate (1) and heavy (2). Low-to-moderate is defined as less than one glass per week to six drinks per week & heavy is defined as seven or more drinks per week:
gen alcohol_qb =.
replace alcohol_qb = 0 if b752_cat ==0 & b753_cat ==0 & b754_cat ==0 & b755_cat ==0 & b756_cat ==0 & b757_cat ==0 & b758_cat ==0 & b759_cat ==0 & b760_cat ==0 & b767_cat ==0 & b768_cat ==0 & b769_cat ==0 & b721_cat ==0 & b722_cat ==0 & b723_bin ==0
replace alcohol_qb = 1 if b752_cat ==1 | b753_cat ==1 | b754_cat ==1 | b755_cat ==1 | b756_cat ==1 | b757_cat ==1 | b758_cat ==1 | b759_cat ==1 | b760_cat ==1 | b767_cat ==1 | b768_cat ==1 | b769_cat ==1 | b721_cat ==1 | b722_cat ==1 | b721_cat ==2 | b722_cat ==2  
replace alcohol_qb = 2 if b752_cat ==2 | b753_cat ==2 | b754_cat ==2 | b755_cat ==2 | b756_cat ==2 | b757_cat ==2 | b758_cat ==2 | b759_cat ==2 | b760_cat ==2 | b767_cat ==2 | b768_cat ==2 | b769_cat ==2 | b721_cat ==3 | b722_cat ==3 | b723_bin ==1
label values alcohol_qb cat_lb
tab alcohol_qb

* e220 is the only question in the E questionnaire that asks about drinking IN pregnancy not postnatally
tab e220, nolabel
replace e220 =. if e220 ==-1
replace e220 = 5 if e220 ==6
gen e220_cat =0 if e220 ==1
replace e220_cat =1 if e220 ==2
replace e220_cat =2 if e220 ==3
replace e220_cat =3 if e220 >=4 & e220 !=.
tab e220_cat
label values e220_cat amounts_lb
tab e220_cat

* Categorical alcohol use reported in the E questionnaire using the same categories as for questionnaire B 
gen alcohol_qe =.
replace alcohol_qe = 0 if e220_cat ==0
replace alcohol_qe = 1 if e220_cat ==1 | e220_cat ==2
replace alcohol_qe = 2 if e220_cat ==3
label values alcohol_qe cat_lb
tab alcohol_qe

* Generating a variable for alcohol exposure during pregnacy we can use in the analysis: none, low-to-moderate and heavy
gen alcohol_preg =.
replace alcohol_preg = 0 if alcohol_qb ==0 & alcohol_qe ==0
replace alcohol_preg = 1 if alcohol_qb ==1 | alcohol_qe ==1
replace alcohol_preg = 2 if alcohol_qb ==2 | alcohol_qe ==2
label values alcohol_preg cat_lb
tab alcohol_preg

* Binary variables comparing low-to-moderate with none and heavy with none for characteristic comparisons
gen ltm_none =.
replace ltm_none = 0 if alcohol_preg == 0
replace ltm_none = 1 if alcohol_preg == 1
label values ltm_none ltm_none_lb
tab ltm_none

gen heavy_none =.
replace heavy_none = 0 if alcohol_preg ==0
replace heavy_none = 1 if alcohol_preg ==2
label values heavy_none heavy_none_lb
tab heavy_none

* For the beer and wine analysis, we will compare low-to-moderate/heavy beer/wine drinkers with non-drinkers and compare them - beer and wine in these groups are mutually exclusive (beer drinkers never reported wine and vice versa) 
* Beer
tab b754_cat
gen beer_cat =.
replace beer_cat = 0 if alcohol_preg ==0
replace beer_cat = 1 if b754_cat ==1 & b757_cat ==0
replace beer_cat = 2 if b754_cat ==2 & b757_cat ==0
label values beer_cat cat_lb
tab beer_cat

* Binary variables for characteristic comparisons
gen beer_cat_ltm =.
replace beer_cat_ltm = 0 if beer_cat ==0
replace beer_cat_ltm = 1 if beer_cat ==1
label values beer_cat_ltm ltm_none_lb
tab beer_cat_ltm

gen beer_cat_heavy =.
replace beer_cat_heavy = 0 if beer_cat ==0
replace beer_cat_heavy = 1 if beer_cat ==2
label values beer_cat_heavy heavy_none_lb
tab beer_cat_heavy

* Wine
tab b757_cat
gen wine_cat =.
replace wine_cat = 0 if alcohol_preg ==0
replace wine_cat = 1 if b757_cat ==1 & b754_cat ==0
replace wine_cat = 2 if b757_cat ==2 & b754_cat ==0
label values wine_cat cat_lb
tab wine_cat

* Binary variables for characteristic comparisons
gen wine_cat_ltm =.
replace wine_cat_ltm = 0 if wine_cat ==0
replace wine_cat_ltm = 1 if wine_cat ==1
label values wine_cat_ltm ltm_none_lb
tab wine_cat_ltm

gen wine_cat_heavy =.
replace wine_cat_heavy = 0 if wine_cat ==0
replace wine_cat_heavy = 1 if wine_cat ==2
label values wine_cat_heavy heavy_none_lb
tab wine_cat_heavy

* Variables related to outcomes - obstretic variables below already clean
tab HDP
tab gesthyp
tab preeclampsia

* Categorical HDP outcome for multinomial logistic regression model
gen hdp_cat =.
replace hdp_cat = 0 if HDP ==0
replace hdp_cat = 1 if gesthyp ==1
replace hdp_cat = 2 if preeclampsia ==1
label values hdp_cat hdp_cat_lb
tab hdp_cat

* Variables related to potential confounders

* Maternal age 
tab matage_del, nolabel
replace matage_del =. if matage_del <0

* Age category for missing data analysis
gen mat_age_cat =.
replace mat_age_cat = 0 if matage_del <25
replace mat_age_cat = 1 if matage_del >=25 & matage_del !=.
label values mat_age_cat mat_age_cat_lb
tab mat_age_cat

* Maternal BMI
tab mat_bmi, nolabel
replace mat_bmi =. if mat_bmi ==-3

* BMI categories for missing data analysis
gen bmi_cat =.
replace bmi_cat = 0 if mat_bmi <18.5
replace bmi_cat = 1 if mat_bmi >=18.5 & mat_bmi <25
replace bmi_cat = 2 if mat_bmi >=25 & mat_bmi <30
replace bmi_cat = 3 if mat_bmi >=30 & mat_bmi !=.
label values bmi_cat bmi_cat_lb
tab bmi_cat 

* Pre-pregnancy smoking - b669 which asks about amount smoked pre-pregnancy (categorical) has more missing data than b663 (binary) so use this in the analysis
tab b663
gen prepreg_smoking =.
replace prepreg_smoking = 0 if b663 ==1
replace prepreg_smoking = 1 if b663 >1 & b663 !=.
label values prepreg_smoking bin_lb
tab prepreg_smoking

* Maternal smoking
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

* Binary variable for smoking in trimester 1
generate smoking_t1 =.
replace smoking_t1 = 0 if smoking_mother_firsttrim_ordinal == 0
replace smoking_t1 = 1 if smoking_mother_firsttrim_ordinal == 1 | smoking_mother_firsttrim_ordinal == 2 | smoking_mother_firsttrim_ordinal == 3
label values smoking_t1 bin_lb
tab smoking_t1

* Number of cigarettes in the second trimester (13 to 26 weeks)
* b721 asks for number smoked in last two weeks, which is second trimester depending in when the questionnaire was filled out & fill in gaps with c482
tab c482
replace c482 =. if c482 == -7 | c482 == -1 | c482 ==.
gen c482_cat =.
replace c482_cat = 0 if c482 == 0 
replace c482_cat = 1 if c482 == 1 | c482 == 2 | c482 == 3 | c482 == 4
replace c482_cat = 5 if c482 == 5 | c482 == 6 | c482 == 7 | c482 == 8 | c482 == 9
replace c482_cat = 10 if c482 == 10 | c482 == 11 | c482 == 12 | c482 == 13 | c482 == 14
replace c482_cat = 15 if c482 == 15 | c482 == 16 | c482 == 17 | c482 == 18 | c482 == 19
replace c482_cat = 20 if c482 == 20 | c482 == 21 | c482 == 22 | c482 == 23 | c482 == 24
replace c482_cat = 25 if c482 == 25 | c482 == 26 | c482 == 27 | c482 == 28 | c482 == 29
replace c482_cat = 30 if c482 >= 30 & c482 <=60
tab c482_cat, nolabel
generate smoking_secondtrim_ordinal =.
replace smoking_secondtrim_ordinal = 0 if (b671 ==0 & b924 >=13 & b924 <=26) | (c482_cat ==0 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 1 if (b671 ==1 & b924 >=13 & b924 <=26) | (c482_cat ==1 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 1 if (b671 ==5 & b924 >=13 & b924 <=26) | (c482_cat ==5 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 2 if (b671 ==10 & b924 >=13 & b924 <=26) | (c482_cat ==10 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 2 if (b671 ==15 & b924 >=13 & b924 <=26) | (c482_cat ==15 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==20 & b924 >=13 & b924 <=26) | (c482_cat ==20 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==25 & b924 >=13 & b924 <=26) | (c482_cat ==25 & c991 >=13 & c991 <=26)
replace smoking_secondtrim_ordinal = 3 if (b671 ==30 & b924 >=13 & b924 <=26) | (c482_cat ==30 & c991 >=13 & c991 <=26)
label values smoking_secondtrim_ordinal smoking_firsttrim_ordinal_lb
tab smoking_secondtrim_ordinal

* Binary variable for smoking in trimester 2
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

replace smoking_thirdtrim_ordinal = 0 if smoking_thirdtrim_ordinal ==. & c482_cat ==0 & c991 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & c482_cat ==1 & c991 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & c482_cat ==5 & c991 >=27  
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & c482_cat ==10 & c991 >=27 
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & c482_cat ==15 & c991 >=27  
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482_cat ==20 & c991 >=27
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482_cat ==25 & c991 >=27 
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & c482_cat ==30 & c991 >=27
tab smoking_thirdtrim_ordinal

replace smoking_thirdtrim_ordinal = 0 if smoking_thirdtrim_ordinal ==. & b671 ==0 & b924 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & b671 ==1 & b924 >=27
replace smoking_thirdtrim_ordinal = 1 if smoking_thirdtrim_ordinal ==. & b671 ==5 & b924 >=27 
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & b671 ==10 & b924 >=27
replace smoking_thirdtrim_ordinal = 2 if smoking_thirdtrim_ordinal ==. & b671 ==15 & b924 >=27  
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==20 & b924 >=27
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==25 & b924 >=27 
replace smoking_thirdtrim_ordinal = 3 if smoking_thirdtrim_ordinal ==. & b671 ==30 & b924 >=27
tab smoking_thirdtrim_ordinal

* Binary variable for smoking in trimester 3
generate smoking_t3 =.
replace smoking_t3 = 0 if smoking_thirdtrim_ordinal == 0
replace smoking_t3 = 1 if smoking_thirdtrim_ordinal == 1 | smoking_thirdtrim_ordinal == 2 | smoking_thirdtrim_ordinal == 3
label values smoking_t3 bin_lb
tab smoking_t3

* Overall binary variable for any smoking during pregnancy
generate smoking_preg =.
replace smoking_preg = 0 if smoking_t1 ==0 & smoking_t2 ==0 & smoking_t3 ==0
replace smoking_preg = 1 if smoking_t1 ==1 | smoking_t2 ==1 | smoking_t3 ==1
label values smoking_preg bin_lb
tab smoking_preg

* Maternal education
tab mat_edu, nolabel
replace mat_edu =. if mat_edu ==-1
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

* Parity 
tab parity, nolabel
replace parity =. if parity <0
* Categorical - Nulliparous, 1, 2 or 3+
gen parity_cat =.
replace parity_cat = 0 if parity ==0
replace parity_cat = 1 if parity ==1
replace parity_cat = 2 if parity ==2
replace parity_cat = 3 if parity >=3 & parity !=.
label values parity_cat parity_cat_lb
tab parity_cat
* Binary - Nulliparous or multiparous
gen parity_bin =.
replace parity_bin = 0 if parity ==0
replace parity_bin = 1 if parity >0 & parity !=.
label values parity_bin parity_lb
tab parity_bin

* Ethnicity
tab mat_ethn, nolabel
replace mat_ethn =. if mat_ethn ==-1
* Binary - White or non-white
gen mat_ethn_bin =.
replace mat_ethn_bin = 0 if mat_ethn ==1
replace mat_ethn_bin = 1 if mat_ethn >1 & mat_ethn !=.
label values mat_ethn_bin ethn_lb
tab mat_ethn_bin

* Save full clean dataset for analysis of missing data
save mp2_clean.dta, replace

* Variables needed for sensitivity analysis 

* Using pre-pregnancy categorical drinking as the exposure
* b720 asks about pre-pregnancy drinking habits
tab b720, nolabel
replace b720 =. if b720 ==-1
replace b720 = 5 if b720 ==6
gen prepreg_cat =.
replace prepreg_cat =. if b720 ==-1
replace prepreg_cat = 0 if b720 ==1
replace prepreg_cat = 1 if b720 ==2 | b720 ==3
replace prepreg_cat = 2 if b720 >=4 & b720 !=.
label values prepreg_cat cat_lb 
tab prepreg_cat

* Dealing with recall bias - restricting the analysis to those answering questionnaire B prior to 20 weeks
tab alcohol_qb if b924 <20
gen alcohol_pre20 = alcohol_qb if b924 <20
label values alcohol_pre20 cat_lb
tab alcohol_pre20

* Separating binge drinking from non-binge drinking for supplementary material
* Splitting out binge drinkers from 7+ drinks a week - heavy non-binge & heavy binge
gen alcohol_preg_binge =.
replace alcohol_preg_binge = 0 if alcohol_qb ==0 & alcohol_qe ==0
replace alcohol_preg_binge = 1 if alcohol_qb ==1 | alcohol_qe ==1
replace alcohol_preg_binge = 2 if alcohol_qb ==2 | alcohol_qe ==2
replace alcohol_preg_binge = 3 if b723_bin ==1
label values alcohol_preg_binge alcohol_preg_binge_lb
tab alcohol_preg_binge

* Generating two variables for comparing heavy non-binge vs none and heavy binge vs none
gen heavy_nonbinge_none =.
replace heavy_nonbinge_none = 0 if alcohol_preg ==0
replace heavy_nonbinge_none = 1 if alcohol_preg_binge == 2
label values heavy_nonbinge_none heavy_nonbinge_none_lb
tab heavy_nonbinge_none

gen heavy_binge_none =.
replace heavy_binge_none = 0 if alcohol_preg ==0
replace heavy_binge_none = 1 if alcohol_preg_binge ==3
label values heavy_binge_none heavy_binge_none_lb
tab heavy_binge_none

* Categorical variable of average cigarettes smoked per day in pregnancy using the max amount they reported anytime during pregnancy - to adequately build the variable, I need to rely on missing values so here I drop if the binary variable for smoking during pregnancy is missing (therefore not a complete cases and being dropped from the analysis anyway) to build stratified smoking covariate
drop if smoking_preg ==.

gen no_smoked_preg =.
replace no_smoked_preg = 0 if (b670 ==0 | b670 ==.) & (b671 ==0 | b671 ==.) & (c482_cat ==0 | c482_cat ==.) & (e178 ==0 | e178 ==.)
replace no_smoked_preg = 1 if b670 ==1 | b671 ==1 | c482_cat ==1 | e178 ==1
replace no_smoked_preg = 5 if b670 ==5 | b671 ==5 | c482_cat ==5 | e178 ==5
replace no_smoked_preg = 10 if b670 ==10 | b671 ==10 | c482_cat ==10 | e178 ==10
replace no_smoked_preg = 15 if b670 ==15 | b671 ==15 | c482_cat ==15 | e178 ==15
replace no_smoked_preg = 20 if b670 ==20 | b671 ==20 | c482_cat ==20 | e178 ==20
replace no_smoked_preg = 25 if b670 ==25 | b671 ==25 | c482_cat ==25 | e178 ==25
replace no_smoked_preg = 30 if b670 ==30 | b671 ==30 | c482_cat ==30 | e178 ==30
tab no_smoked_preg

* We want to drop those who have pre-existing hypertension as we are measuring incidence not prevalence
drop if prev_hyp ==1

* Now for the complete case analysis (CCA) drop any members in the population who have missing data (we have already dropped those who had smoking during pregnancy missing)
drop if alcohol_preg ==.
drop if mat_bmi ==. 
drop if matage_del ==.   
drop if mat_edu ==. 
drop if marital_status ==.
drop if prepreg_smoking ==.
drop if parity ==. 
drop if mat_ethn ==.  
drop if HDP ==.

save mp2_cca.dta, replace

