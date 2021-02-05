# Analysis plan for MP2
Author: Flo Martin
Date:   05/02/2021

## Research question
Is alcohol consumption in pregnancy associated with hypertensive disorders of pregnancy (and their respective placental abnormalities) and gestational diabetes?

## Overview
Alcohol use in pregnancy has been associated with many adverse outcomes for mother and baby - it is hypothesised that it might play a role in pregnancy complications, including placenta-associated syndromes, such as preeclampsia. We want to understand whether low-to-moderate drinking in pregnancy exihibits a dose-response effect on identified associations for outcomes, as well as trimester specific analyses of drinking. Given that alcohol crosses the placenta easily and the abnormalities observed in pregnancies complicated by conditions like preeclampsia, we will use the data on placentas available in ALSPAC to investigate associations between alcohol exposure in pregnancy and placental abnormalities.

We will first describe the overall prevalence of these complications in ALSPAC, then stratify by drinking anytime during pregnancy for each outcome: HDP, preeclampsia, gestational diabetes and placenta weight:birth weight ratio. To understand how different patterns of drinking affect potential associations we will stratify by low-to-moderate and binge drinking. We will also examine trimester-specific exposure to alcohol. These exposure definitions will be explored in uni- and multivariate logisitic regression analyses. We will summarise these findings as odds ratios and 95% confidence intervals.   

### Section 1 - Preparing & cleaning the ALSPAC data

- [ ] _**Extract ALSPAC Data**_
    - [ ] Extract variables for the **exposure**: alcohol use in pregnancy from prenatal questionnaires:
        - `a252` `a255` `a258a` `a260` `a261` `a210-a214` for alcohol use at 8 weeks gestation
        - `b032` `b043` `b044` `b370` `b650` `b720-b724` `b730` `b754` `b757` `b760`  `b769` for alcohol use at 18 weeks gestation
        - `c052` `c360` `c363` `c366` `c369` `c372` `c373` `c482` `c483` for alcohol use at 32 weeks gestation  
    - [ ] Extract variables for the **outcomes**: pregnancy-related complications including placental measures:
        - `preeclampsia`
        - `HDP` hypertensive disorders of pregnancy
        - `gesthyp` gestational hypertension
        - `d047` hypertension in pregnancy
        - `v1dab6k_diabetes` `pregnancy_diabetes` `d041` diabetes in pregnancy
        - `kz033` `kz033a` placental weight
        - `kz030b` birtweight from obstetric data (for placental weight:birth weight ratio)      
    - [ ] Extract **covariates** for the multivariate logistic regression analysis:
        - `dw042` maternal body mass index (BMI)
        - `b670` `b671` smoking in trimester 1
        - `c482` smoking in trimester 2
        - `e178` smoking in trimester 3
        - `mz024b` year of delivery
        - `c645a` maternal education
        - `d168` `d168a` history of alcoholism
        - `a525` marital status
        - `mz028b` maternal age at delivery    
    - [ ] Extract variables that show during which trimester each questionnaire was completed in:
        - `a902` `b924` `c991` gestation at completion
        
 - [ ] _**Clean & prepare ALSPAC variables for EWAS**_
    - [ ] Rename each variable from ALSPAC identifier to easy to recognise name
    - [ ] Assign labels to each category within the categorical variables for ease of use, using the built PDFs in the ALSPAC catalogue
    - [ ] Replace any "Missing" or "Not stated" or -10 etc. categories with `.` for compatability with Stata
    - [ ] Switch the order of yes and no 1 and 2 to yes and no 0 and 1
    - [ ] Derive separate clean exposure variables of interest:
        - `alcohol_use_ever` for any alcohol use any time during pregnancy
        - `binge_drinking` for within alcohol users, binary variable for bingeing ever yes or no; no indicating low-to-moderate use
        - `alcohol_t1` `alcohol_t2` `alcohol_t3` for trimester-specific alcohol use
    - [ ] Derive clean outcome variable for placenta weight:birth weight ratio:
        - `pw_bw_ratio` divide placental weight by birth weight in grams
    - [ ] Derive clean covariate variable for smoking during pregnancy:
        - Use EPoCH code the same as MP1

### Section 2 - Analysing the data

- [ ] _**Analyse the data**_
    - [ ] Univariate logistic regression analyses of alcohol consumption in pregnancy on each outcome: preeclampsia, gestational hypertension, gestational diabetes           & PW:BW ratio
    - [ ] Multivariate logistic regression analyses of alcohol consumption in pregnancy on each outcome adjusted for maternal age, BMI, education, marital status,             history of alcoholism & hypertension, smoking during pregnancy and year of delivery
    - [ ] Sub-group analyses of binge-drinking vs low-to-moderate drinking on each pregnancy
    - [ ] Trimester specific analyses of any alcohol use and drinking pattern (if adequately powered) on each outcome

- [ ] _**Sensitivity analysis**_
    - [ ] Stratify by drink type to account for unmeasured socioeconomic confounding not captured by maternal education
    - [ ] Negative control analysis of paternal drinking during pregnancy
        
:tada: Finished Mini Project Two! :tada:    
    
        
