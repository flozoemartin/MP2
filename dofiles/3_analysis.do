
* Analysing complete case MP2 dataset using negative control analysis, beer/wine analysis and sensitivity analyses *

* Author: Flo Martin

* Date started: 26/02/2021
* Date finished: 05/10/2021

* Contents *
* line 39 - Characteristic comparison for table 1

* Negative control analysis
* line 61 - Primary analysis in the full maternal cohort: maternal drinking and HDP, unadjusted & adjusted
* line 103 - Primary analysis in the negative control cohort: maternal drinking and HDP, unadjusted, adjusted & mutually adjusted
* line 141 - Negative control analysis in negative control cohort: partner drinking and HDP, unadjusted, adjusted & mutually adjusted

* Positive control analysis 
* line 185 - Positive control analysis of NCA in full maternal cohort: maternal smoking during pregnancy and HDP, unadjusted & adjusted
* line 206 - Positive control analysis of NCA in negative control cohort: maternal smoking during pregnancy and HDP, unadjusted, adjusted & mutually adjusted
* line 228 - Positive control analysis of NCA in negative control cohort: partner smoking during pregnancy and HDP, unadjusted, adjusted & mutually adjusted

* Beer wine analysis 
* line 263 - Beer
* line 294 - Wine

* Sensitivity analyses
* line 326 - Using pre-pregnancy alcohol use as the exposure
* line 361 - Stratifying smoking covariate from binary into categorical (number smoked per day during pregnancy)
* line 393 - Excluding those who responded to questionnaire B post-20 weeks' gestation
* line 435 - Excluding those who reported to abstain from alcohol prior to pregnancy

* Start logging
log using "$Logdir/log_analysis.txt", text replace

* Load in the data
cd "$Projectdir/datafiles"
use mp2_cca.dta, clear

* Table 1 - characterisitics of low-to-moderate and heavy drinkers as compared with non-drinkers during pregnancy

	tab alcohol_preg

	foreach n in 0 1 2 {
		summ matage_del if alcohol_preg==`n'
	}
	
	foreach n in 0 1 2 {
		summ mat_bmi if alcohol_preg==`n'
	}
	 
	tab alcohol_preg prepreg_smoking, row
	
	tab alcohol_preg smoking_preg, row

	tab alcohol_preg parity_bin, row

	tab alcohol_preg mat_ethn_bin, row

	tab alcohol_preg mat_degree, row

	tab alcohol_preg married_bin, row
	
	* Partner characteristics

	use mp2_nca.dta, clear

	tab pat_alcohol_preg

	foreach n in 0 1 2 {
		summ patage if pat_alcohol_preg==`n'
	}
	
	foreach n in 0 1 2 {
		summ pat_bmi if pat_alcohol_preg==`n'
	}
	
	tab pat_alcohol_preg pat_smoking_bin, row

	tab pat_alcohol_preg parity_bin, row

	tab pat_alcohol_preg pat_ethn_bin, row

	tab pat_alcohol_preg pat_degree, row

	tab pat_alcohol_preg pat_married, row

* Primary analysis - any alcohol use during pregnancy using alcohol_preg and HDP/hdp_cat 

* Population
* ALSPAC mothers

* Exposure
tab alcohol_preg

* Outcome
tab HDP
tab hdp_cat

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.8701 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption during pregnancy ~ HDP, unadjusted & adjusted
logistic HDP alcohol_preg, or 
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.6192 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy ~ hdp_cat, unadjusted & adjusted
mlogit hdp_cat alcohol_preg, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Primary analysis but in the negative control cohort
use mp2_nca.dta, clear

* Population
* ALSPAC mothers

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.8480 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption during pregnancy ~ HDP, unadjusted, adjusted & mutually adjusted
logistic HDP alcohol_preg, or 
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin i.pat_alcohol_preg, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.9882 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy ~ hdp_cat, unadjusted, adjusted & mutually adjusted
mlogit hdp_cat alcohol_preg, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin i.pat_alcohol_preg, base(0) rrr

* Negative control analysis - partner's drinking during pregnancy

* Population 
* ALSPAC partners

* Exposure
tab pat_alcohol_preg

* Outcome
tab HDP
tab hdp_cat

* Proportions of those with HDP in each partner drinking group
tab HDP pat_alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for pat_alcohol_preg
logistic HDP pat_alcohol_preg, or
est store A
logistic HDP i.pat_alcohol_preg, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.9184 so we don't need both coefficients

* Logistic regression analysis - partner alcohol consumption during pregnancy ~ HDP, unadjusted, adjusted & mutually adjusted
logistic HDP pat_alcohol_preg, or
logistic HDP pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin, or
logistic HDP pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin i.alcohol_preg, or

* Proportions of those with gestational hypertension or preeclampsia in each partner drinking group
tab hdp_cat pat_alcohol_preg, col

* Checking using a likelihood ratio test whether we need an indicator for pat_alcohol_preg
mlogit hdp_cat pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.5924 so we don't need both coefficients

* Multinomial logistic regression analysis - partner alcohol consumption during pregnancy ~ hdp_cat, unadjusted, adjusted & mutually adjusted
mlogit hdp_cat pat_alcohol_preg, base(0) rrr
mlogit hdp_cat pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin, base(0) rrr
mlogit hdp_cat pat_alcohol_preg pat_bmi patage pat_smoking_bin i.pat_edu pat_married i.parity_cat pat_ethn_bin i.alcohol_preg, base(0) rrr

* Positive control for the negative control - do the same analysis but using smoking as the exposure which has a well-documented, robust negative association with development of HDP
* Firstly do the analysis in the full cohort
use mp2_cca.dta, replace

* Population
* ALSPAC mothers

* Proportions of those with HDP in each smoking group
tab HDP smoking_preg, col

* Logistic regression analysis - maternal smoking during pregnancy ~ HDP, unadjusted & adjusted 
logistic HDP smoking_preg, or 
logistic HDP smoking_preg mat_bmi matage_del prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg, or

* Proportions of those with gestational hypertension or preeclampsia in each smoking group
tab hdp_cat smoking_preg, col

* Multinomial logistic regression analysis - maternal smoking during pregnancy ~ hdp_cat, unadjusted & adjusted 
mlogit hdp_cat smoking_preg, base(0) rrr
mlogit hdp_cat smoking_preg mat_bmi matage_del prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg, base(0) rrr

* Then in the negative control cohort as before
use mp2_nca.dta, clear

* Population
* ALSPAC mothers

* Proportions of those with HDP in each smoking group
tab HDP smoking_preg, col

* Logistic regression analysis - maternal smoking during pregnancy ~ HDP, unadjusted, adjusted & mutually adjusted
logistic HDP smoking_preg, or
logistic HDP smoking_preg mat_bmi matage_del i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg, or
logistic HDP smoking_preg mat_bmi matage_del i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg pat_smoking_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each smoking group
tab hdp_cat smoking_preg, col

* Multinomial logistic regression analysis - maternal smoking during pregnancy ~ hdp_cat, unadjusted, adjusted & mutually adjusted
mlogit hdp_cat smoking_preg, base(0) rrr
mlogit hdp_cat smoking_preg mat_bmi matage_del i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg, base(0) rrr
mlogit hdp_cat smoking_preg mat_bmi matage_del i.mat_edu married_bin i.parity_cat mat_ethn_bin i.alcohol_preg pat_smoking_bin, base(0) rrr

* Now, similarly to the analysis of drinking, the same analysis is run using partner's smoking during pregnancy

* Population
* ALSPAC partners

* Proportions of those with HDP in each partner smoking group
tab HDP pat_smoking_bin, col

* Logistic regression analysis - partner smoking during pregnancy ~ HDP, unadjusted, adjusted & mutually adjusted
logistic HDP pat_smoking_bin, or
logistic HDP pat_smoking_bin pat_bmi patage i.pat_edu pat_married i.parity_cat pat_ethn_bin i.pat_alcohol_preg, or
logistic HDP pat_smoking_bin pat_bmi patage i.pat_edu pat_married i.parity_cat pat_ethn_bin i.pat_alcohol_preg i.smoking_preg, or

* Proportions of those with gestational hypertension or preeclampsia in each partner smoking group
tab hdp_cat pat_smoking_bin, col

* Multinomial logistic regression analysis - partner smoking during pregnancy ~ hdp_cat, unadjusted, adjusted & mutually adjusted
mlogit hdp_cat pat_smoking_bin, base(0) rrr
mlogit hdp_cat pat_smoking_bin pat_bmi patage i.pat_edu pat_married i.parity_cat pat_ethn_bin i.pat_alcohol_preg, base(0) rrr
mlogit hdp_cat pat_smoking_bin pat_bmi patage i.pat_edu pat_married i.parity_cat pat_ethn_bin i.pat_alcohol_preg i.smoking_preg, base(0) rrr

* Beer and wine analysis to tease out any more residual confounding by SEP - low-to-moderate and heavy beer/wine drinkers are compared with non-drinkers. Those in the beer drinking group did not report wine drinking in questionnaire B and vice versa.
use mp2_cca.dta, clear

* Population
* ALSPAC mothers

* Exposure
tab beer_cat
tab wine_cat

* Outcome
tab HDP
tab hdp_cat

* Beer
* Proportions of those with HDP in each beer drinking group
tab HDP beer_cat, col

* Checking using a likelihood ratio test whether we need an indicator for beer_cat
logistic HDP beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3755 so we don't need both coefficients

* Logistic regression analysis - beer consumption during pregnancy ~ HDP, unadjusted & adjusted
logistic HDP beer_cat, or
logistic HDP beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each beer drinking group
tab hdp_cat beer_cat, col

* Checking using a likelihood ratio test whether we need an indicator for beer_cat
mlogit hdp_cat beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.6704 so we don't need both coefficients

* Multinomial logistic regression analysis - beer consumption during pregnancy ~ HDP, unadjusted & adjusted
mlogit hdp_cat beer_cat, base(0) rrr
mlogit hdp_cat beer_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Wine
* Proportions of those with HDP in each wine drinking group
tab HDP wine_cat, col

* Checking using a likelihood ratio test whether we need an indicator for wine_cat
logistic HDP wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3559 so we don't need both coefficients

* Logistic regression analysis - wine consumption during pregnancy ~ HDP, unadjusted & adjusted
logistic HDP wine_cat, or
logistic HDP wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each wine drinking group
tab hdp_cat wine_cat, col

* Checking using a likelihood ratio test whether we need an indicator for wine_cat
mlogit hdp_cat wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B 
* The output of the likelihood ratio test if 0.6897 so we don't need both coefficients

* Multinomial logistic regression analysis - wine consumption during pregnancy ~ HDP, unadjusted & adjusted
mlogit hdp_cat wine_cat, base(0) rrr
mlogit hdp_cat wine_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Sensitivity analyses
* Using pre-pregnancy alcohol consumption as the exposure

* Population
* ALSPAC mothers

* Proportions of those with HDP in each pre-pregnancy drinking group
tab HDP prepreg_cat, col

* Checking using a likelihood ratio test whether we need an indicator for prepreg_cat
logistic HDP prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.7816 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption before pregnancy ~ HDP, unadjusted & adjusted
logistic HDP prepreg_cat, or
logistic HDP prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each pre-pregnancy drinking group
tab hdp_cat prepreg_cat, col

* Checking using a likelihood ratio test whether we need an indicator for prepreg_cat
mlogit hdp_cat prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3501 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption before pregnancy ~ HDP, unadjusted & adjusted
mlogit hdp_cat prepreg_cat, base(0) rrr
mlogit hdp_cat prepreg_cat mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Stratifying the variable for smoking during pregnancy used in the analysis as a covariate - may be residual confounding as smoking is strongly associated with the outcome

* Population
* ALSPAC mothers

* Exposure
tab alcohol_preg

* Outcome
tab HDP
tab hdp_cat

* Smoking covariates
tab smoking_preg
tab no_smoked_preg

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg, col

* Logistic regression analysis - alcohol consumption during pregnancy ~ HDP, unadjusted, adjusted (binary smoking during pregnancy) & adjusted (categorical smoking during pregnancy)
logistic HDP alcohol_preg, or 
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
logistic HDP alcohol_preg mat_bmi matage_del i.no_smoked_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg, col

* Multinomial logistic regression analysis - alcohol consumption during pregnancy ~ hdp_cat, unadjusted, adjusted (binary smoking during pregnancy) & adjusted (categorical smoking during pregnancy
mlogit hdp_cat alcohol_preg, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del i.no_smoked_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Excluding those who responded to questionnaire B >20 weeks' gestation

* Population
* ALSPAC mothers

* Exposure 
tab alcohol_pre20

* Outcomes
tab HDP
tab hdp_cat

* Proportions of those with HDP in each drinking group
tab HDP alcohol_pre20, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_pre20
logistic HDP alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store A
logistic HDP i.alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.6422 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption before pregnancy ~ HDP, unadjusted & adjusted
logistic HDP alcohol_pre20, or
logistic HDP alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_pre20, col

* Checking using a likelihood ratio test whether we need an indicator for prepreg_cat
mlogit hdp_cat alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.9108 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy (pre-20 weeks' gestation) ~ hdp_cat, unadjusted & adjusted
mlogit hdp_cat alcohol_pre20, base(0) rrr
mlogit hdp_cat alcohol_pre20 mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin, base(0) rrr

* Excluding those who reported to have been abstaining from alcohol prior to pregnancy

* Population
* ALSPAC mothers

* Exposure 
tab alcohol_preg if prepreg_cat !=0

* Outcomes
tab HDP
tab hdp_cat

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg if prepreg_cat !=0, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, or
est store A
logistic HDP i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.7274 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption during pregnancy (excluding pre-pregnancy abstainers) ~ HDP, unadjusted & adjusted
logistic HDP alcohol_preg if prepreg_cat !=0, or
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg if prepreg_cat !=0, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.6279 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy (excluding pre-pregnancy abstainers) ~ hdp_cat, unadjusted & adjusted
mlogit hdp_cat alcohol_preg if prepreg_cat !=0, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if prepreg_cat !=0, base(0) rrr

* Excluding those who reported to have diabetes, kidney disease, arthritis or non-singleton pregnancies

* Population
* ALSPAC mothers

* Exposure 
tab alcohol_preg if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2

* Outcomes
tab HDP
tab hdp_cat

* Proportions of those with HDP in each drinking group
tab HDP alcohol_preg if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, or
est store A
logistic HDP i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, or
est store B
lrtest A B
* The output of the likelihood ratio test if 0.2935 so we don't need both coefficients

* Logistic regression analysis - alcohol consumption during pregnancy (excluding diabetes, kidney disease, arthritis and non-singleton pregnancies) ~ HDP, unadjusted & adjusted
logistic HDP alcohol_preg if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, or
logistic HDP alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, or

* Proportions of those with gestational hypertension or preeclampsia in each drinking group
tab hdp_cat alcohol_preg if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, col

* Checking using a likelihood ratio test whether we need an indicator for alcohol_preg
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, base(0) rrr
est store A
mlogit hdp_cat i.alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, base(0) rrr
est store B
lrtest A B
* The output of the likelihood ratio test if 0.3982 so we don't need both coefficients

* Multinomial logistic regression analysis - alcohol consumption during pregnancy (excluding pre-pregnancy abstainers) ~ hdp_cat, unadjusted & adjusted
mlogit hdp_cat alcohol_preg if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, base(0) rrr
mlogit hdp_cat alcohol_preg mat_bmi matage_del smoking_preg prepreg_smoking i.mat_edu married_bin i.parity_cat mat_ethn_bin if v1dab6k_diabetes!=1 & d159a!=1 & d163a!=1 & mz010a!=2, base(0) rrr


* Stop logging
log close
