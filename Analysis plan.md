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

### Section 1 - Preparing & cleaning the ALSPAC data

- [x] _**Extract ALSPAC Data**_
    - [x] Extract variables for the maternal **exposure**: alcohol use in pregnancy from prenatal questionnaires B & E:
        - `b032` `b043` `b044` `b370` `b650` `b720-b724` `b730` `b754` `b757` `b760`  `b769` for alcohol use at 18 weeks gestation
        - `e220` for alcohol use in the last two months of pregnancy (questionnaire sent at 8 weeks' postpartum)
    - [ ] Extract variables for the partner's **negative control exposure**: alcohol use during participant's pregnancy PB & PC:
        - `pb100` for alcohol use in the three months prior to filling out the questionnaire (18 weeks' gestation)
        - `pc280` for alcohol use in the last two months of the pregnancy (8 weeks' postpartum)  
    - [ ] Extract variables for the **outcomes**: HDP, gestational hypertension and preeclampsia:
        - `preeclampsia`
        - `HDP` hypertensive disorders of pregnancy
        - `gesthyp` gestational hypertension
        - `prev_hyp` hypertension in pregnancy (for exclusion - measuring incidence of HDP not prevalent cases of hypertension)   
    - [ ] Extract maternal **covariates** for the multivariate logistic regression analysis:
        - `mz028b` maternal age at delivery 
        - `a525` marital status at 8 weeks' gestation
        - `dw042` maternal body mass index (BMI)at 12 weeks' gestation
        - `b663` for pre-pregnancy smoking
        - `b670` `b671` `c482` `e178` smoking throughout pregnancy (used to build binary ever/never during pregnancy variable)
        - `c645a` maternal education at 32 weeks' gestation
        - `c800` maternal ethnicity at 32 weeks' gestation
    - [ ] Extract partner's **covariates** for the negative control multivariate logistic regression analysis:
        - `mz028b` partner's age at delivery 
        - `paw010` height and weight to calculate partner's body mass index (BMI)at 18 weeks' gestation
        - `b663` for pre-pregnancy smoking
        - `b670` `b671` `c482` `e178` smoking throughout pregnancy (used to build binary ever/never during pregnancy variable)
        - `pb325a` partner's education at 18 weeks' gestation
        - `pa065` marital status at 8 weeks' gestation
        - `pb440` partner's ethnicity at 18 weeks' gestation
           
    - [ ] Extract variables that show during which trimester each questionnaire was completed in:
        - `a902` `b924` `c991` gestation at completion
     
    - [ ] Extract variables for sensitivity analyses:
        - `b720` for pre-pregnancy drinking
        
 - [ ] _**Clean & prepare ALSPAC variables for EWAS**_
    - [ ] Rename each variable from ALSPAC identifier to easy to recognise name
    - [ ] Assign labels to each category within the categorical variables for ease of use, using the built PDFs in the ALSPAC catalogue
    - [ ] Replace any "Missing" or "Not stated" or -10 etc. categories with `.` for compatability with Stata
    - [ ] Switch the order of yes and no 1 and 2 to yes and no 0 and 1
    - [ ] Derive separate clean exposure variables of interest:
        - `alcohol_preg` for any alcohol use any time during pregnancy: none (0), low-to-moderate (1) defined as 1 - 6 drinks per week & heavy (2) defined as 7+                drinks per week
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
    
        
