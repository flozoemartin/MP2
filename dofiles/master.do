
* Author: 		Flo Martin

* Date: 		5th October 2021

* Description: 	Master file to run all do files in the correct order for alcohol intake & maternal hypertensive disorders of pregnancy project

* Contents
* 1 - Run global.do
* 2 - Cleaning
* 3 - Analyses
* 4 - Figures
* 5 - Multiple imputation
* 6 - Supplementary material

* 1 - Run global.do - sets the directories for project
do "/Users/ti19522/Documents/GitHub/MP2/dofiles/global.do"


* 2 - Cleaning
do "$Dodir/1_cleaning_mat.do"		// Raw data duplicated & cleaned - full & complete maternal datasets created
do "$Dodir/2_cleaning_pat.do"		// Raw data duplicated & cleaned - complete maternal & partner datasets created


* 3 - Analyses
do "$Dodir/3_analysis.do"		// Descriptive & substantive analyses


* 4 - Figures
do "$Dodir/4_figures.do"		// Create figures 2, 3 & 4


* 5 - Supplementary				
do "$Dodir/5_supplementary.do"	// Generate supplementary material (for populating tables)



