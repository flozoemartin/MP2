
* Figures for "Association between alcohol in pregnancy and HDP: a negative control approach using ALSPAC" *

* Author: Flo Martin *

* Date started: 01/05/2021 *

* Date finished: 02/06/2021 *

* Contents *
* line 15 - Figure 2 Negative control analysis *
* line 95 - Figure 3 Beer wine analysis *
* line 154 - Figure 4 Sensitivity analyses *

* Start logging
log using "$Logdir/log_figures.txt", text replace

* Change directory for saving graphs
cd "$Projectdir/graphfiles"

* Install package for combining graphs
net install grc1leg, from (http://www.stata.com/users/vwiggins)

* Figure 2 - negative control analysis 
clear
input id gr or lci uci
0.95	0	.845	.775	.92
1.15	1	.837	.749	.935
1.35	2	.857	.765	.960
1.95	0	.860	.786	.942
2.15	1	.851	.758	.956
2.35	2	.873	.776	.984
2.95	0	.736	.589	.919
3.15	1	.735	.554	.975
3.35	2	.745	.558	.994
3.95	0	.674	.531	.855
4.15	1	.640	.522	.785
4.35	2	.655	.529	.812
4.95	0	.723	.562	.929
5.15	1	.699	.566	.864
5.35	2	.713	.570	.890
5.95	0	.413	.229	.742
6.15	1	.299	.159	.562
6.35	2	.319	.166	.610
end

set scheme s1mono
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==0, mcolor(gs11) mlcolor(black) mlwidth(.1) ms(t)) ///
		(scatter id or if gr ==1, mcolor(gs7) mlcolor(black) mlwidth(.1) ms(o)) /// 
		(scatter id or if gr ==2, mcolor(black) mlcolor(black) ms(d)) /// 
		, legend(order(2 "Full maternal cohort adjusted" "{it:n} = 8,999" 3 "Negative control analysis cohort adjusted" "{it:n} = 5,376" 4 "Negative control analysis cohort mutually adjusted" "{it:n} = 5,376") pos(5) ring(1) row(1) size(*0.5)) /// 
		ylabel(1.15 `""Hypertensive disorder" "of pregnancy (HDP)""' 2.15 "Gestational hypertension" 3.15 "Preeclampsia" 4.15  `""Hypertensive disorder" "of pregnancy (HDP)""' 5.15 "Gestational hypertension" 6.15 "Preeclampsia", nogrid angle(horizontal) labsize(*0.8)) ytitle("") ///
		xlabel(0.3(0.2)1.5,format(%03.1f) labsize(*0.6) nogrid) /// 
		title("{bf}Maternal exposure", size(small)) ///
		b2title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.6 6.4) lstyle(none)) ///
		xscale(log range(0.15 1.1)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		yline(3.6, lpattern(solid) lcolor(black))  ///
		text(0.62 0.21 "{bf}Maternal alcohol", size(small)) ///
		text(3.73 0.217 "{bf}Maternal smoking", size(small)) ///
		fxsize(85) fysize(100) ///
		name(mat, replace) 

clear
input id gr or lci uci
1.15	1	.786	.671	.921
1.35	2	.823	.700	.967
2.15	1	.775	.656	.917
2.35	2	.807	.680	.957
3.15	1	.864	.576	1.30
3.35	2	.947	.629	1.43
4.15	1	.855	.728	1.00
4.35	2	.965	.814	1.14
5.15	1	.884	.747	1.05
5.35	2	.975	.815	1.17
6.15	1	.672	.439	1.03
6.35	2	.890	.573	1.38
end

set scheme s1mono
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==1, mcolor(gs7) mlcolor(black) mlwidth(.1) ms(o)) /// 
		(scatter id or if gr ==2, mcolor(black) ms(d)) /// 
		, legend(order(2 "Adjusted" 3 "Mutually adjusted") pos(5) ring(1) row(2) size(*0.5)) /// 
		ylabel("", nogrid) ytitle("") ///
		xlabel(0.3(0.2)1.5,format(%03.1f) labsize(*0.6) nogrid) /// 
		title("{bf} Partner's exposure", size(small)) ///
		b2title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.6 6.4) lstyle(none)) ///
		xscale(log range(0.15 1.1)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		yline(3.6, lpattern(solid) lcolor(black))  ///
		text(0.62 0.215 "{bf}Partner's alcohol", size(small)) ///
		text(3.73 0.22 "{bf}Partner's smoking", size(small)) ///
		fxsize(55) fysize(100) ///
		name(pat, replace) 

* Combine sections of the graph
grc1leg2 mat pat, row(1) ring(1) pos(5) graphregion(color(white)) legendfrom(mat) name(fig_2, replace)

* Save figure 2 as .tif in graphfiles
graph export fig_2.tif, name(fig_2) replace

* Figure 3 - beer and wine analysis
* Using beer drinking as the exposure (binary any/none)
clear
input id gr or lci uci
1.05 0 0.845 0.775 0.920
1.15 1 0.889 0.738 1.07
1.35 0 0.860 0.786 0.942
1.45 1 0.916 0.753 1.11
1.65 0 0.736 0.589 0.919
1.75 1 0.725 0.438 1.20
end	

set scheme s1mono	
		
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==0, mcolor(gs11) mlcolor(black) mlwidth(.1) ms(t)) /// 
		(scatter id or if gr ==1, mcolor(black) ms(s)) /// 
		, legend(order(2 "Full maternal cohort adjusted" "{it:n} = 8,999"  3 "Stratified by beer adjusted" "{it:n} = 3,065") pos(5) ring(2) row(1) size(*0.5)) /// 
		ylabel(1.1 `""Hypertensive disorder" "of pregnancy (HDP)""' 1.4 "Gestational hypertension" 1.7 "Preeclampsia", nogrid angle(horizontal) labsize(*0.8)) ytitle("") ///
		xlabel(0.5(0.2)1.3,format(%03.1f) labsize(*0.6) nogrid) /// 
		b1title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.93 1.8) lstyle(none)) ///
		xscale(log range(0.5 1.3)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		text(0.93 0.46 "{bf}Beer", size(small)) ///
		fxsize(100) fysize(50) ///
		name(beer, replace) 
		
* Using wine drinking as the exposure (binary any/none)
clear
input id gr or lci uci
1.05 0 0.845 0.775 0.920
1.15 1 0.784 0.667 0.921
1.35 0 0.860 0.786 0.942
1.45 1 0.814 0.688 0.963
1.65 0 0.736 0.589 0.919
1.75 1 0.574 0.361 0.913
end	
		
set scheme s1mono	
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==0, mcolor(gs11) mlcolor(black) mlwidth(.1) ms(t)) /// 
		(scatter id or if gr ==1, mcolor(black) ms(o)) /// 
		, legend(order(2 "Full maternal cohort adjusted" "{it:n} = 8,999"  3 "Stratified by wine adjusted" "{it:n} = 3,798") pos(5) ring(2) row(1) size(*0.5)) /// 
		ylabel("", nogrid) ytitle("") ///
		xlabel(0.5(0.2)1.3,format(%03.1f) labsize(*0.6) nogrid) /// 
		b1title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.93 1.8) lstyle(none)) ///
		xscale(log range(0.5 1.3)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		text(0.93 0.385 "{bf}Wine", size(small)) ///
		fxsize(65) fysize(50) ///
		name(wine, replace) 

* Combine sections of the graph
graph combine beer wine, row(1) graphregion(color(white)) name(fig_3, replace)

* Save figure 3 as .tif in graphfiles
graph export fig_3.tif, name(fig_3) replace

* Figure 4 - four sensitivity analyses
* Using pre-pregnancy drinking as the exposure & excluding those who responded after 20 weeks' gestation
clear
input id gr or lci uci
1.05 0 0.845 0.775 0.920
1.15 1 0.873 0.757 1.01
1.35 0 0.860 0.786 0.942
1.45 1 0.866 0.745 1.01
1.65 0 0.736 0.589 0.919
1.75 1 0.926 0.645 1.33
2.05 0 0.845 0.775 0.920
2.15 1 0.842 0.769 0.923
2.35 0 0.860 0.786 0.942
2.45 1 0.855 0.777 0.940
2.65 0 0.736 0.589 0.919
2.75 1 0.755 0.597 0.954
end	
		
set scheme s1mono	
		
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==0, mcolor(gs11) mlcolor(black) mlwidth(.1) ms(t)) /// 
		(scatter id or if gr ==1, mcolor(black) ms(t)) /// 
		, legend(order(2 "Full maternal cohort adjusted" "{it:n} = 8,999" 3 "Sensitivity analysis") pos(5) ring(2) row(1) size(*0.5)) /// 
		ylabel(1.1 `""Hypertensive disorder" "of pregnancy (HDP)""' 1.4 "Gestational hypertension" 1.7 "Preeclampsia" 2.1 `""Hypertensive disorder" "of pregnancy (HDP)""' 2.4 "Gestational hypertension" 2.7 "Preeclampsia", nogrid angle(horizontal) labsize(*0.8)) ytitle("") ///
		xlabel(0.5(0.2)1.5,format(%03.1f) labsize(*0.6) nogrid) /// 
		b1title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.93 2.8) lstyle(none)) ///
		xscale(log range(0.5 1.55)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		yline(1.9, lpattern(solid) lcolor(black))  ///
		text(0.93 1.38 "{it:n} = 8,987", size(small)) ///
		text(1.95 1.38 "{it:n} = 6,001", size(small)) ///
		text(0.93 0.52 "{bf}(i)", size(small)) ///
		text(1.95 0.52 "{bf}(iii)", size(small)) ///
		fxsize(85) fysize(100) ///
		name(fig_4_col_1, replace) 

* Stratifying smoking covariate into categorical number per day & excluding abstainer's prior to pregnancy
clear
input id gr or lci uci
1.05 0 0.845 0.775 0.920
1.15 1 0.842 0.775 0.921
1.35 0 0.860 0.786 0.942
1.45 1 0.860 0.786 0.942
1.65 0 0.736 0.589 0.919
1.75 1 0.738 0.590 0.922
2.05 0 0.845 0.775 0.920
2.15 1 0.833 0.752 0.924
2.35 0 0.860 0.786 0.942
2.45 1 0.849 0.763 0.946
2.65 0 0.736 0.589 0.919
2.75 1 0.715 0.539 0.949
end	
		
set scheme s1mono	
		
twoway  (rcap lci uci id, horizontal) /// 
		(scatter id or if gr ==0, mcolor(gs11) mlcolor(black) mlwidth(.1) ms(t)) /// 
		(scatter id or if gr ==1, mcolor(black) ms(t)) /// 
		, legend(order(2 "Full maternal cohort adjusted" "{it:n} = 8,999" 3 "Sensitivity analysis") pos(5) ring(2) row(1) size(*0.5)) /// 
		ylabel("", nogrid angle(horizontal) labsize(*0.8)) ytitle("") ///
		xlabel(0.5(0.2)1.5,format(%03.1f) labsize(*0.6) nogrid) /// 
		b1title("{bf:Ratio measure (95%CI)}", size(small) margin (0 2)) /// 
		yscale(reverse r(0.93 2.8) lstyle(none)) ///
		xscale(log range(0.5 1.55)) ///
		graphregion(color(white) margin(-2 0 0 0)) ///
		xline(1.0, lpattern(dash) lcolor(red))  ///
		yline(1.9, lpattern(solid) lcolor(black))  ///
		text(0.93 1.38 "{it:n} = 8,999", size(small)) ///
		text(1.95 1.38 "{it:n} = 8,450", size(small)) ///
		text(0.93 0.52 "{bf}(ii)", size(small)) ///
		text(1.95 0.52 "{bf}(iv)", size(small)) ///
		fxsize(55) fysize(100) ///
		name(fig_4_col_2, replace) 

* Combine sections of the graph
grc1leg2 fig_4_col_1 fig_4_col_2, row(1) ring(1) pos(6) graphregion(color(white)) legendfrom(fig_4_col_1) title("Sensitivty analyses", size(small) color(white)) name(fig_4, replace)

* Save figure 3 as .tif in graphfiles
graph export fig_4.tif, name(fig_4) replace

* Stop logging
log close
