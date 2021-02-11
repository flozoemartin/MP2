
* Analysing MP2 dataset

* Author: 			Flo Martin

* Date started: 	11/02/2021
* Date finished: 

cd "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis"
use mp2_analysis.dta, clear

* For the demographic characteristics

tab abstain_duringonly

tab mat_bmi, chi
summ mat_bmi if abstain_duringonly ==0
summ mat_bmi if abstain_duringonly ==1

summ matage_del if abstain_duringonly ==0
summ matage_del if abstain_duringonly ==1

tab abstain_duringonly smoking_preg, col chi

tab abstain_duringonly prev_hyp, col chi

tab abstain_duringonly alcoholism_bin, col chi

tab abstain_duringonly mat_degree, col chi

tab abstain_duringonly married_bin, col chi
