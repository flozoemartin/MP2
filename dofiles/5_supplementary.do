
* Supplementary material for manuscript - alcohol consumption during pregnancy & HDP *

* Author: Flo Martin

* Date started: 01/05/2021
* Date finished: 05/10/2021

* Contents *
* Missing data exploration
* line 29 - Table 1 Summary of variables in the full cohort & restricted (complete case) cohort for exposure, outcome & covariates
* line 37 - Table 2 Predictors of being a complete case in available data for each variable in the analysis

* Beer wine analysis 
* line 47 - Table 9 Characteristics of beer drinkers (low-to-moderate & heavy) compared with non-drinkers
* line 68 - Table 11 Characteristics of wine drinkers (low-to-moderate & heavy) compared with non-drinkers
* line 90 - Table 13 Prevalence of binge drinking & other alcohol consumption in beer/wine drinkers

* Analysis of binge drinkers
* line 98 - Table 14 Characteristics of low-to-moderate, heavy non-binge & heavy binge compared with non-drinkers
* line 121 - Table 15 Comparison of HDP in low-to-moderate, heavy non-binge & heavy binge drinkers using logistic regression and multinomial logistic regression

* Start logging
log using "$Logdir/log_supplementary.txt", text replace

* Change the directory to the location of the data
cd "$Projectdir/datafiles"

* Missing data exploration (as per framework set out by Lee et al. (2021))
* Table 1 Summary of variables in the full cohort & restricted (complete case) cohort for exposure, outcome & covariates
use mp2_clean.dta, replace
tab1 alcohol_preg mat_age_cat bmi_cat prepreg_smoking smoking_preg parity_bin mat_ethn_bin mat_degree married_bin hdp_cat 

use mp2_cca.dta, replace
tab1 alcohol_preg mat_age_cat bmi_cat prepreg_smoking smoking_preg parity_bin mat_ethn_bin mat_degree married_bin hdp_cat

* Table 2 Predictors of being a complete case in available data for each variable in the analysis
use mp2_clean.dta, replace

foreach varname of varlist alcohol_preg mat_age_cat bmi_cat prepreg_smoking smoking_preg parity_bin mat_ethn_bin mat_degree married_bin HDP {
	logistic cc `varname', or
}

* Beer wine analysis
use mp2_cca.dta, replace

*  Table 9 Characteristics of beer drinkers (low-to-moderate & heavy) compared with non-drinkers
tab beer_cat_ltm
ttest matage_del, by(beer_cat_ltm)
ttest mat_bmi, by(beer_cat_ltm) 
tab prepreg_smoking beer_cat_ltm, col chi
tab smoking_preg beer_cat_ltm, col chi
tab parity_bin beer_cat_ltm, col chi
tab mat_ethn_bin beer_cat_ltm, col chi
tab mat_degree beer_cat_ltm, col chi
tab married_bin beer_cat_ltm, col chi

tab beer_cat_heavy
ttest matage_del, by(beer_cat_heavy)
ttest mat_bmi, by(beer_cat_heavy) 
tab prepreg_smoking beer_cat_heavy, col chi
tab smoking_preg beer_cat_heavy, col chi
tab parity_bin beer_cat_heavy, col chi
tab mat_ethn_bin beer_cat_heavy, col chi
tab mat_degree beer_cat_heavy, col chi
tab married_bin beer_cat_heavy, col chi

* Table 11 Characteristics of wine drinkers (low-to-moderate & heavy) compared with non-drinkers

tab wine_cat_ltm
ttest matage_del, by(wine_cat_ltm)
ttest mat_bmi, by(wine_cat_ltm) 
tab prepreg_smoking wine_cat_ltm, col chi
tab smoking_preg wine_cat_ltm, col chi
tab parity_bin wine_cat_ltm, col chi
tab mat_ethn_bin wine_cat_ltm, col chi
tab mat_degree wine_cat_ltm, col chi
tab married_bin wine_cat_ltm, col chi

tab wine_cat_heavy
ttest matage_del, by(wine_cat_heavy)
ttest mat_bmi, by(wine_cat_heavy) 
tab prepreg_smoking wine_cat_heavy, col chi
tab smoking_preg wine_cat_heavy, col chi
tab parity_bin wine_cat_heavy, col chi
tab mat_ethn_bin wine_cat_heavy, col chi
tab mat_degree wine_cat_heavy, col chi
tab married_bin wine_cat_heavy, col chi

* Table 13 Prevalence of binge drinking & other alcohol consumption in beer/wine drinkers

* Beer and wine bingeing compared
tab b723_bin beer_wine, col chi m

* Beer and wine spirit consumption compared
tab extra_drinking beer_wine, col chi

* Table 14 Characteristics of low-to-moderate, heavy non-binge & heavy binge compared with non-drinkers
* Fill in the first three columns using Table 1 (low-to-moderate vs non-drinker comparison)

tab heavy_nonbinge_none
ttest matage_del, by(heavy_nonbinge_none)
ttest mat_bmi, by(heavy_nonbinge_none) 
tab prepreg_smoking heavy_nonbinge_none, col chi
tab smoking_preg heavy_nonbinge_none, col chi
tab parity_bin heavy_nonbinge_none, col chi
tab mat_ethn_bin heavy_nonbinge_none, col chi
tab mat_degree heavy_nonbinge_none, col chi
tab married_bin heavy_nonbinge_none, col chi

tab heavy_binge_none
ttest matage_del, by(heavy_binge_none)
ttest mat_bmi, by(heavy_binge_none) 
tab prepreg_smoking heavy_binge_none, col chi
tab smoking_preg heavy_binge_none, col chi
tab parity_bin heavy_binge_none, col chi
tab mat_ethn_bin heavy_binge_none, col chi
tab mat_degree heavy_binge_none, col chi
tab married_bin heavy_binge_none, col chi

* Table 15 Comparison of HDP in low-to-moderate, heavy non-binge & heavy binge drinkers using logistic regression and multinomial logistic regression

* Population
* ALSPAC mothers

* Exposure
tab alcohol_preg_binge

* Outcome
tab HDP
tab hdp_cat

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg_binge, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
logistic HDP alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3188 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption during pregnancy ~ HDP, unadjusted & adjusted
logistic HDP alcohol_preg_binge, or 
logistic HDP alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg_binge, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
mlogit hdp_cat alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3445 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy ~ hdp_cat, unadjusted & adjusted
mlogit hdp_cat alcohol_preg_binge, base(0) rrr
mlogit hdp_cat alcohol_preg_binge mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Stop logging
log close
