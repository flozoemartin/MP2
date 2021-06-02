# Analysis plan for MP2
Author: Flo Martin    
Date:   05/02/2021

## Research question
Is alcohol consumption in pregnancy associated with hypertensive disorders of pregnancy?

## Overview
Alcohol use in pregnancy has been associated with many adverse outcomes for mother and baby - it is hypothesised that it might play a role in pregnancy complications, including hypertensive disorders of pregnancy (HDP), such as gestational hypertension and preeclampsia. We want to understand whether drinking during pregnancy exihibits a dose-response effect on identified associations for HDP. The literature in this area is conflicting, which most studies suggesting that alcohol consumption reduces risk of HDP, although two have found the opposite. Given that alcohol consumption outside of pregnancy has been consistently linked to increased blood pressure and increased risk of suffering from adverse events, a finding to suggest that alcohol would be associated with a reduction in risk of HDP doesn't make a lot of sense.

We will first describe the risk of each outcome, HDP, gestational hypertension and preeclampsia following alcohol consumption any time during pregnancy in ALSPAC. To understand how different patterns of drinking affect potential associations we will stratify by none, low-to-moderate (1 - 6 drinks per week) and heavy (7+ drinks per week) drinking. This exposure will be explored in uni- and multivariate logisitic regression analyses for HDP (generating odds ratios) and multinomial logistic regression for normotensive, gestational hypertension or preeclampsia (generating relative risk ratios). We will perform the same analysis is a subset of the maternal cohort who have complete data on themselves and their partners, to utilise a negative control approach. This will be directly compared to an analysis of risk of maternal HDP following partner's alcohol consumption during pregnancy, mutually adjusting for maternal drinking. To test the robustness of our negative control model, we tested the hypothesis that maternal smoking but not partner smoking is associated with a decreased risk of HDP.

In order to investigate any residual confounding by socioeconomic position (SEP), we will investigate the effects of beer and wine drinking during pregnancy. Those who drink wine have been shown to be characteristically different from those who drink other alcoholic drinks and those who do not drink. We will investigate different types of drink as the exposure, using maternal HDP as the outcome.

We will also run a series of sensitivity analyses: (1) excluding participants' who responded after 20 weeks' gestation, (2) excluding participants' who abstained from alcohol prior to pregnancy, (3) stratifying smoking covariate by number smoked per day (categorical) as opposed to any/none during pregnancy (binary), and (4) using pre-pregnancy drinking as the exposure. 

## Section 1 - Preparing & cleaning the ALSPAC data

- [x] _**Extract ALSPAC Data**_
    - [x] Extract variables for the maternal **exposure**: alcohol use in pregnancy from prenatal questionnaires B & E:
        - `b032` `b043` `b044` `b370` `b650` `b720-b724` `b730` `b754` `b757` `b760`  `b769` for alcohol use at 18 weeks gestation
        - `e220` for alcohol use in the last two months of pregnancy (questionnaire sent at 8 weeks' postpartum)
        - `b754` `b757` for beer & wine consumption, respectively
    - [x] Extract variables for the partner's **negative control exposure**: alcohol use during participant's pregnancy PB & PC:
        - `pb100` for alcohol use in the three months prior to filling out the questionnaire (18 weeks' gestation)
        - `pc280` for alcohol use in the last two months of the pregnancy (8 weeks' postpartum)  
    - [x] Extract variables for the **outcomes**: HDP, gestational hypertension and preeclampsia:
        - `preeclampsia`
        - `HDP` hypertensive disorders of pregnancy
        - `gesthyp` gestational hypertension
        - `prev_hyp` hypertension in pregnancy (for exclusion - measuring incidence of HDP not prevalent cases of hypertension)   
    - [x] Extract maternal **covariates** for the multivariate logistic regression analysis:
        - `mz028b` maternal age at delivery 
        - `a525` marital status at 8 weeks' gestation
        - `dw042` maternal body mass index (BMI)at 12 weeks' gestation
        - `b663` for pre-pregnancy smoking
        - `b670` `b671` `c482` `e178` smoking throughout pregnancy (used to build binary ever/never during pregnancy variable)
        - `c645a` maternal education at 32 weeks' gestation
        - `c800` maternal ethnicity at 32 weeks' gestation
    - [x] Extract partner's **covariates** for the negative control multivariate logistic regression analysis:
        - `mz028b` partner's age at delivery 
        - `paw010` height and weight to calculate partner's body mass index (BMI)at 18 weeks' gestation
        - `b663` for pre-pregnancy smoking
        - `b670` `b671` `c482` `e178` smoking throughout pregnancy (used to build binary ever/never during pregnancy variable)
        - `pb325a` partner's education at 18 weeks' gestation
        - `pa065` marital status at 8 weeks' gestation
        - `pb440` partner's ethnicity at 18 weeks' gestation
           
    - [x] Extract variables that show during which week gestation each questionnaire was completed in:
        - `a902` `b924` `c991` gestation at completion
     
    - [x] Extract variables for sensitivity analyses:
        - `b723` for binge drinking
        - `b720` for pre-pregnancy drinking
        
 - [x] _**Clean & prepare ALSPAC variables for maternal cohort in mp2.dta**_
    - [x] Clean variables of interest - recode negatives as missing, change labels to match built PDFs and reorder yes/no
    - [x] Derive overall exposure variable for alcohol use during pregnancy (categorical - none, low-to-moderate & heavy):
        - `alcohol_preg` for any alcohol use any time during pregnancy using variables from questionnaires B & E
             - none (0) at any point during pregnancy
             - low-to-moderate (1) defined as 1 - 6 drinks per week 
             - heavy (2) defined as 7+ drinks per week   
    - [x] Derive outcome variable for HDP (cateogorical - normotensive, gestational hypertension & preeclampsia):
        - `hdp_cat` for hypertensive disorders of pregnancy using obstetric variables `HDP`, `gesthyp` & `preeclampsia`
            - HDP = 0 (0) 
            - if GH = 1 (1) 
            - if PE = 1 (2)
    - [x] Derive covariate variable for any smoking during pregnancy (binary - any & none):
        - Use EPoCH code the same as MP1 using `b670`, `b671`, `c482` & `e178` along with gestation at completion variables `a902`, `b924` & `c991`
    - [x] Save `mp2_clean.dta` for analysis of missing data
    - [x] Drop participant's with hypertension diagnosed before pregnancy and incomplete cases (for exposure, outcome or covariates) & save as `mp2_cca.dta`
  
 - [x] _**Clean & prepare ALSPAC variables for partner cohort in mp2.dta**_
    - [x] Clean variables of interest - recode negatives as missing, change labels to match built PDFs and reorder yes/no
    - [x] Derive overall exposure variable for alcohol use during pregnancy (categorical - none, low-to-moderate & heavy):
        - `pat_alcohol_preg` for any alcohol use any time during pregnancy: none (0), low-to-moderate (1) defined as 1 - 6 drinks per week & heavy (2) defined as 7+ drinks per week using all available alcohol-related variables in questionnaires PB & PC
    - [x] Derive covariate variable for any smoking during pregnancy (binary - any & none):
        - Use EPoCH code the same as MP1 using `pb078` & `pb079` for early & present smoking 
 - [x] Replicate maternal data cleaning in this dataset for the tandem maternal analysis in the negative control cohort
 - [x] Save `mp2_nca.dta` for negative control analysis

At this stage, will have two datasets derived from the extract: `mp2_cca.dta` for the primary & sensitivity analyses (which includes complete maternal cases) and `mp2_nca.dta` for the negative control analyses (which includes complete maternal & partner cases)

## Section 2 - Analysing the data

- [x] _**Negative control analysis of drinking during pregnancy in `mp2_cca.dta` & `mp2_nca.dta`**_
    
    **Maternal alcohol consumption during pregnancy in full cohort** 
    - Logistic regression analysis - unadjusted:
        - Maternal alcohol consumption in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal alcohol consumption in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia) 
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, smoking before & during during pregnancy and ethnicity 
    
    **Maternal alcohol consumption during pregnancy in negative control cohort**    
    - Logistic regression analysis - unadjusted:
        - Maternal alcohol consumption in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal alcohol consumption in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia)
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, smoking before & during during pregnancy and ethnicity
    - Both models adjusted for all covariates & mutually adjusted for partner's alcohol consumption in pregnancy
    
    **Partner alcohol consumption during pregnancy in negative control cohort**  
    - Logistic regression analysis - unadjusted:
        - Partner's alcohol consumption in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Partner's alcohol consumption in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia)
    - Both models adjusted for partner's age, BMI, educational attainment, marital status, smoking during during pregnancy and ethnicity
    - Both models adjusted for all covariates & mutually adjusted for maternal alcohol consumption in pregnancy
  
- [x] _**Positive control of negative control using smoking during pregnancy in `mp2_cca.dta` & `mp2_nca.dta`**_
    
    **Maternal smoking during pregnancy in full cohort** 
    - Logistic regression analysis - unadjusted:
        - Maternal smoking in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal smoking in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia) 
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, alcohol consumption during pregnancy and ethnicity
   
   **Maternal smoking during pregnancy in negative control cohort** 
    - Logistic regression analysis - unadjusted:
        - Maternal smoking in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal smoking in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia)
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, alcohol consumption during pregnancy and ethnicity
    - Both models adjusted for all covariates & mutually adjusted for partner's smoking in pregnancy
    
    **Partner smoking during pregnancy in negative control cohort**
    - Logistic regression analysis - unadjusted:
        - Partner's smoking in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Partner's smoking in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia)
    - Both models adjusted for partner's age, BMI, educational attainment, marital status, alcohol consumption during pregnancy and ethnicity
    - Both models adjusted for all covariates & mutually adjusted for maternal smoking in pregnancy
   
- [x] _**Analysis of beer & wine in `mp2_cca.dta`**_

    **Maternal beer consumption during pregnancy in full cohort** - exposure here consists of no alcohol consumption during pregnancy (0), low-to-moderate consumption of beer (1) & heavy consumption of beer (2) in those who never reported wine consumption
    - Logistic regression analysis - unadjusted:
        - Maternal beer consumption in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal beer consumption in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia) 
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, smoking before & during during pregnancy and ethnicity 

     **Maternal wine consumption during pregnancy in full cohort** - exposure here consists of no alcohol consumption during pregnancy (0), low-to-moderate consumption of wine (1) & heavy consumption of wine (2) in those who never reported beer consumption
    - Logistic regression analysis - unadjusted:
        - Maternal wine consumption in pregnancy ~ HDP (binary - normotensive or HDP) 
    - Multinomial logistic regression analysis - unadjusted:
        - Maternal wine consumption in pregnancy ~ HDP (categorical - normotensive, gestational hypertension or preeclampsia) 
    - Both models adjusted for maternal age, BMI, educational attainment, marital status, smoking before & during during pregnancy and ethnicity 

- [x] _**Sensitivity analysis**_
    - Exclude those who responded to questionnaire B after 20 weeks' and answers from questionnaire E
    - Exclude those who abstained from alcohol prior to pregnancy
    - Stratify smoking covariate by number smoked per day
    - Use pre-pregnancy alcohol use as the exposure

## Section 3 - Writing up
Write up the manuscript for this work with a journal in mind (Hypertension?).


:tada: **Finished Mini Project Two**! :tada:  
