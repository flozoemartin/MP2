
* Preparing complete case MP2 dataset for negative control analysis *

* Author: Flo Martin *

* Date started: 15/03/2021 *
* Date finished: 05/10/2021 *

* Contents *
* line 27 - Labels *
* line 66 - Partner variables *
* line 63 - Exposure *
* line 106 - Confounder variables *
* line 192 - Maternal variables *
* line 698 - save NCA dataset *

* Start logging
log using "$Logdir/log_cleaning_pat.txt", text replace

* Load in the data
cd "$Projectdir/rawdata"
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

* Variables denoting when questionnaires were filled out
tab a902, nolabel
replace a902 =. if a902 ==-1
tab b924
replace b924 =. if b924 ==-1
tab c991
replace c991 =. if c991 <0

* Partner variables 
* Exposure
* Binge-drinking
tab pb101, nolabel
replace pb101 =. if pb101 ==-1

gen pb101_bin =.
replace pb101_bin = 0 if pb101 ==0
replace pb101_bin = 1 if pb101 >0 & pb101 !=.
label values pb101_bin bin_lb
tab pb101_bin

* Last three months
tab pb100
replace pb100 =. if pb100 ==-1
gen pb100_cat =.
replace pb100_cat = 0 if pb100 ==1 
replace pb100_cat = 1 if pb100 ==2 | pb100 ==3
replace pb100_cat = 2 if pb100 >=4 & pb100 !=.
label values pb100_cat weekly_lb
tab pb100_cat

* Last two months pregnancy
tab pc280
replace pc280 =. if pc280 ==-1
gen pc280_cat =.
replace pc280_cat = 0 if pc280 ==1 
replace pc280_cat = 1 if pc280 ==2 | pc280 ==3
replace pc280_cat = 2 if pc280 >=4 & pc280 !=.
label values pc280_cat weekly_lb
tab pc280_cat

* Derive same variable for drinking alcohol during pregnancy as was derived for mum
gen pat_alcohol_preg =.
replace pat_alcohol_preg = 0 if pb100_cat ==0 & pb101_bin ==0 & pc280_cat ==0
replace pat_alcohol_preg = 1 if pb100_cat ==1 | pc280_cat ==1
replace pat_alcohol_preg = 2 if pb100_cat ==2 | pc280_cat ==2
label values pat_alcohol_preg cat_lb
tab pat_alcohol_preg 

* Confounding variables
* Partner age at time of filling out B questionnaire
tab patage
replace patage =. if patage ==-1

* Converting partner height (paw010) from cm to m
tab paw010
replace paw010 =. if paw010 <0
replace paw010 = paw010/100
* Partner weight (kg)
tab paw002
* Deriving paternal BMI from height (cm) and weight (kg)
gen pat_bmi = (paw002/(paw010)^2)
tab pat_bmi

* Partner smoking during the pregnancy
tab pb078, nolabel
replace pb078 =. if pb078 ==-1
generate smoking_father_ordinal_early =.
replace smoking_father_ordinal_early =. if pb078 ==.
replace smoking_father_ordinal_early = 0 if pb078 ==0 
replace smoking_father_ordinal_early = 1 if pb078 ==1 
replace smoking_father_ordinal_early = 1 if pb078 ==5 
replace smoking_father_ordinal_early = 2 if pb078 ==10 
replace smoking_father_ordinal_early = 2 if pb078 ==15 
replace smoking_father_ordinal_early = 3 if pb078 ==20 
replace smoking_father_ordinal_early = 3 if pb078 ==25 
replace smoking_father_ordinal_early = 3 if pb078 ==30
label values smoking_father_ordinal_early smoking_lb
tab smoking_father_ordinal_early

tab pb079
replace pb079 =. if pb079 ==-1
generate smoking_father_ordinal_present =.
replace smoking_father_ordinal_present =. if pb079 ==.
replace smoking_father_ordinal_present = 0 if pb079 ==0 
replace smoking_father_ordinal_present = 1 if pb079 ==1 
replace smoking_father_ordinal_present = 1 if pb079 ==5 
replace smoking_father_ordinal_present = 2 if pb079 ==10 
replace smoking_father_ordinal_present = 2 if pb079 ==15 
replace smoking_father_ordinal_present = 3 if pb079 ==20 
replace smoking_father_ordinal_present = 3 if pb079 ==25 
replace smoking_father_ordinal_present = 3 if pb079 ==30
label values smoking_father_ordinal_present smoking_lb
tab smoking_father_ordinal_present

* Partner smoking status any time during pregnancy - categorical
gen pat_smoking =.
replace pat_smoking = 0 if smoking_father_ordinal_early ==0 & smoking_father_ordinal_present ==0
replace pat_smoking = 1 if smoking_father_ordinal_early ==1 | smoking_father_ordinal_present ==1
replace pat_smoking = 2 if smoking_father_ordinal_early ==2 | smoking_father_ordinal_present ==2
replace pat_smoking = 3 if smoking_father_ordinal_early ==3 | smoking_father_ordinal_present ==3
label values pat_smoking smoking_lb
tab pat_smoking

* Partner smoking status any time during pregnancy - binary
tab pat_smoking, nolabel
gen pat_smoking_bin =.
replace pat_smoking_bin = 0 if pat_smoking ==0
replace pat_smoking_bin = 1 if pat_smoking >0 & pat_smoking !=.
label values pat_smoking_bin bin_lb
tab pat_smoking_bin

* Partner marital status
tab pa065
replace pa065 =. if pa065 ==-1
gen pat_married =.
replace pat_married =0 if pa065 >=1 & pa065 <=4
replace pat_married =1 if pa065 ==5 | pa065 ==6
label values pat_married bin_lb
tab pat_married

* Partner ethnicity
tab pat_ethn
replace pat_ethn =. if pat_ethn ==-1
* Binary partner ethnicity - White or non-white
gen pat_ethn_bin =.
replace pat_ethn_bin = 0 if pat_ethn ==1
replace pat_ethn_bin = 1 if pat_ethn >1 & pat_ethn !=.
label value pat_ethn_bin ethn_lb
tab pat_ethn_bin

* Highest partner educational attainment
tab pat_edu
replace pat_edu =. if pat_edu ==-1

* Maternal variables cleaning script lifted from Cleaning CCA data.do

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

* We want to drop those who have pre-existing hypertension as we are measuring incidence not prevalence
drop if prev_hyp ==1

* Drop incomplete maternal variables as done for the CCA cohort
drop if alcohol_preg ==.
drop if mat_bmi ==. 
drop if matage_del ==.   
drop if mat_edu ==. 
drop if marital_status ==.
drop if prepreg_smoking ==.
drop if parity ==. 
drop if mat_ethn ==. 
drop if smoking_preg ==.
drop if HDP ==.

* Now, drop incomplete partner variables for the negative control analysis (NCA) cohort (so complete cases for both mother & partner)
drop if pat_alcohol_preg ==.
drop if pat_bmi ==. 
drop if patage ==.  
drop if pat_edu ==. 
drop if pat_married ==.
drop if pat_ethn_bin ==. 
drop if pat_smoking ==.

* Save clean dataset including those with complete exposure, maternal exposure & covariate data n=5,376
save "$Datadir/mp2_nca.dta", replace

* Stop logging
log close

