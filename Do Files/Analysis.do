
* Analysing complete case MP2 dataset using negative control analysis, beer/wine analysis and sensitivity analyses *

* Author: Flo Martin

* Date started: 26/02/2021
* Date finished: 02/06/2021

* Contents *
* line - Primary analysis in the full maternal cohort: maternal drinking and HDP
* line - Primary analysis in the negative control cohort: maternal drinking and HDP, both adjusted & mutually adjusted
* line - Negative control analysis in NCA cohort: partner drinking and HDP, both adjusted & mutually adjusted
* line - Positive control analysis of NCA: mother/partner smoking during pregnancy and HDP, both adjusted & mutually adjusted

cd "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis"
use mp2_cca.dta, replace

* Table 1 - characterisitics of low-to-moderate and heavy drinkers as compared with non-drinkers during pregnancy

tab ltm_none
ttest matage_del, by(ltm_none)
ttest mat_bmi, by(ltm_none) 
tab prepreg_smoking ltm_none, col chi
tab smoking_preg ltm_none, col chi
tab parity_bin ltm_none, col chi
tab mat_ethn_bin ltm_none, col chi
tab mat_degree ltm_none, col chi
tab married_bin ltm_none, col chi

tab heavy_none
ttest matage_del, by(heavy_none)
ttest mat_bmi, by(heavy_none) 
tab prepreg_smoking heavy_none, col chi
tab smoking_preg heavy_none, col chi
tab parity_bin heavy_none, col chi
tab mat_ethn_bin heavy_none, col chi
tab mat_degree heavy_none, col chi
tab married_bin heavy_none, col chi

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
cd "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis"
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

* Supplementary material

