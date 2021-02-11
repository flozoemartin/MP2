* This template is based on that used by the data buddy team and they include a number of variables by default.
* To ensure the file works we suggest you keep those in and just add any relevant variables that you need for your project.


****************************************************************************************************************************************************************************************************************************
* To add data other than that included by default you will need to add the relvant files and pathnames in each of the match commands below.
* There is a separate command for mothers questionnaires, mothers clinics, partner, mothers providing data on the child and data provided by the child themselves.
* Each has different withdrawal of consent issues so they must be considered separately.
* You will need to replace 'YOUR PATHNAME' in each section with your working directory pathname.

*****************************************************************************************************************************************************************************************************************************.

* Mother questionnaire files - in this section the following files need to be placed:
* Mother completed Qs about herself
* Maternal grandparents social class
* Partner_proxy social class

* ALWAYS KEEP THIS SECTION EVEN IF ONLY MOTHER CLINIC REQUESTED

clear
set maxvar 32767	
use "/Volumes/Data/Current/Other/Sample Definition/mz_5a.dta", clear
sort aln
gen in_mz=1
merge 1:1 aln using "/Volumes/Data/Current/Quest/Mother/d_4b.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Quest/Mother/a_3e.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Quest/Mother/b_4f.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Quest/Mother/c_8a.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Quest/Mother/e_4f.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Other/Sample Definition/mz_5a.dta", nogen
merge 1:1 aln using "/Volumes/Data/Useful_data/bestgest/bestgest.dta", nogen

keep aln mz001 mz010a mz013 mz014 mz028b ///
a006 a252 - a260 a525 ///
b032 b650 b663 - b667 b754 b757 b760 b769  ///
c645a c755 c765 c800 - c804 ///
d046 d047 d048 d041 d043 dw042 ///
a213 a258 a259 a260 a261 a902 ///
b720 b721 b722 b724 b723 b730 b767 b768 b769 b670 b671 b924 ///
c360 c363 c366 c369 c370 c371 c372 c373 c991 c482 ///
d168 d168a ///
e220 e178 ///
mz024b ///
bestgest

* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before bestgest, so replace the *** line above with additional variables. 
* If none are required remember to delete the *** line.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln mz010a, first
order bestgest, last

do "/Volumes/Data/Syntax/Withdrawal of consent/mother_quest_WoC.do"

* Check withdrawal of consent frequencies mum quest=21
tab1 mz010a, mis

save "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/motherQ.dta", replace


********************************************************************************************************
* Mother clinic files - in this section the following files need to be placed:
* Mother clinc data
* Mother biosamples
* Obstetrics file OB

* If there are no mother clinic files, this section can be starred out *
* NOTE: having to keep mz010a bestgest just to make the withdrawal of consent work - these are dropped for this file as the ones in the Mother questionnaire file are the important ones and should take priority *

use "/Volumes/Data/Current/Other/Sample Definition/mz_5a.dta", clear
sort aln
gen in_mz=1
merge 1:1 aln using "/Volumes/Data/Useful_data/bestgest/bestgest.dta", nogen
merge 1:1 aln using "/Volumes/Data/Current/Other/Obstetric/OB_1b.dta", nogen

keep aln mz001 mz010a ///
DEL_P1044 DEL_P1045 DEL_P1402 DEL_P1403 ///
bestgest

* Removing withdrawl of consent cases *** FOR LARGE DATASETS THIS CAN TAKE A FEW MINUTES
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln mz010a, first
order bestgest mz001, last

do "/Volumes/Data/Syntax/Withdrawal of consent/mother_quest_WoC.do"

* Check withdrawal of consent frequencies mum clinic=22
tab1 mz010a, mis

save "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/motherC.dta", replace


*****************************************************************************************************************************************************************************************************************************.
/* PARTNER - ***UNBLOCK SECTION WHEN REQUIRED***
* Partner files - in this section the following files need to be placed:
* Partner completed Qs about themself
* Partner clinic data
* Partner biosamples data
* Paternal grandparents social class
* Partner_complete social class


* NOTE: having to keep mz010a bestgest just to make the withdrawal of consent work - these are dropped for this file *

use "R:\Data\Current\Other\Sample Definition\mz_5a.dta", clear
sort aln
gen in_mz=1
merge 1:1 aln using "R:\Data\Useful_data\bestgest\bestgest.dta", nogen


keep aln mz001 mz010a ///
/* add in additional variables here */
bestgest

* Removing withdrawl of consent cases *** FOR LARGE DATASETS THIS CAN TAKE A FEW MINUTES
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln mz010a, first
order bestgest mz001, last

do "R:\Data\Syntax\Withdrawal of consent\partner_WoC.do"

* Check withdrawal of consent frequencies partner=3
tab1 mz010a, mis

save "YOUR PATHNAME\partner.dta", replace */



*****************************************************************************************************************************************************************************************************************************.
* Child BASED files - in this section the following files need to be placed:
* Mother completed Qs about YP
* Obstetrics file OA

* ALWAYS KEEP THIS SECTION EVEN IF ONLY CHILD COMPLETED REQUESTED, although you will need to remove the *****

use "/Volumes/Data/Current/Other/Sample Definition/kz_5c.dta", clear
sort aln qlet
gen in_kz=1
merge 1:1 aln qlet using "/Volumes/Data/Current/Other/cohort profile/cp_2b.dta", nogen
merge 1:1 aln qlet using "/Volumes/Data/Current/Other/Obstetric/OA_r1b.dta", nogen

keep aln qlet kz011b kz021 kz030 kz033 kz033a ///
prev_hyp HDP preeclampsia sup_preeclampsia gesthyp v1dab6k_diabetes pregnancy_diabetes v1dae3a1_weight_placenta v1dae3a2_not_wghtd_placenta ///
in_core in_alsp in_phase2 in_phase3 in_phase4 tripquad


* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before in_core, so replace the ***** line with additional variables.
* If none are required remember to delete the ***** line.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln qlet kz021, first
order in_alsp tripquad, last

do "/Volumes/Data/Syntax/Withdrawal of consent/child_based_WoC.do"

* Check withdrawal of consent frequencies child based=22 (two mums of twins have withdrawn consent)
tab1 kz021, mis

save "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/childB.dta", replace

*****************************************************************************************************************************************************************************************************************************.
* Child COMPLETED files - in this section the following files need to be placed:
* YP completed Qs
* Puberty Qs
* Child clinic data
* Child biosamples data
* School Qs
* Obstetrics file OC

* If there are no child completed files, this section can be starred out.
* NOTE: having to keep kz021 tripquad just to make the withdrawal of consent work - these are dropped for this file as the ones in the child BASED file are the important ones and should take priority

use "/Volumes/Data/Current/Other/Sample Definition/kz_5c.dta", clear
sort aln qlet
merge 1:1 aln qlet using "/Volumes/Data/Current/Other/cohort profile/cp_2b.dta", nogen
merge 1:1 aln qlet using "/Volumes/Data/Current/Other/Obstetric/OC_1c.dta", nogen
merge 1:1 aln qlet using "/Volumes/Data/Current/Other/Samples/Child/Child_bloods_4d.dta", nogen

keep aln qlet kz021 ///
DEL_B3000 DEL_B3001 DEL_B3002 ///
Placenta_Abnormal Placenta_Length Placenta_Breadth Placenta_Cotyledons Placenta_Thickness Placenta_Weight Placenta_CordLen Placenta_Distance1 Placenta_Distance2 Placenta_Distance3 Placenta_Comments ///
tripquad

* Dealing with withdrawal of consent: For this to work additional variables required have to be inserted before tripquad, so replace the ***** line with additional variables.
* An additional do file is called in to set those withdrawing consent to missing so that this is always up to date whenever you run this do file

order aln qlet kz021, first
order tripquad, last

do "/Volumes/Data/Syntax/Withdrawal of consent/child_completed_WoC.do"

* Check withdrawal of consent frequencies child completed=24
tab1 kz021, mis

drop kz021 tripquad
save "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/childC.dta", replace

*****************************************************************************************************************************************************************************************************************************.
** Matching all data together and saving out the final file*.
* NOTE: any linkage data should be added here*.

use "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/childB.dta", clear
merge 1:1 aln qlet using "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/childC.dta", nogen
merge m:1 aln using "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/motherQ.dta", nogen
* IF mother clinic data is required please unstar the following line
merge m:1 aln using "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/Data/motherC.dta", nogen 
* IF partner data is required please unstar the following line
/* merge m:1 aln using "YOUR PATHWAY\partner.dta", nogen */


* Remove non-alspac children.
drop if in_alsp!=1.

* Remove trips and quads.
drop if tripquad==1

drop in_alsp tripquad
save "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/mp2.dta", replace

*****************************************************************************************************************************************************************************************************************************.
* QC checks*
use "/Users/ti19522/OneDrive - University of Bristol/Documents/PhD/Year 1/Mini Project 2/Analysis/mp2.dta", clear

* Check that there are 15645 records.
count
