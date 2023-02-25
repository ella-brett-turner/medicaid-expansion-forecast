capture program drop write_index
program define write_index
	syntax, table(string) title(string) workbook(string)

	cap macro list SummaryTableNum
	if (_rc == 111) {
		global SummaryTableNum = 1
	}
	
	local row = 7 + ${SummaryTableNum}
	
	putexcel set "`workbook'", modify sheet("Index")
	putexcel A`row' = formula(`"=HYPERLINK("#'`table''!A1", "`table'")"')
	putexcel B`row' = "`title'"
	
end

capture program drop set_characteristics
program define set_characteristics
	
	su statefip
	global smax = r(max)
	global smin = r(min)
	if $smax == $smin global statefip_global = $smax
	if $smax != $smin{
		pause on
		*di "ERROR: More than one state specified."
		pause ERROR: More than one state specified.
		pause off
	}

	merge m:1 ID using "${BaseDir}\Data\a_additional", keepusing(puma)
	keep if _merge == 3
	drop _merge
	
	merge m:1 statefip puma using "${BaseDir}\Data\ratingregions\hrr", keepusing(rr_num)
	keep if _merge == 3
	drop _merge 
	
	capture describe area
	if (_rc == 111) { 
		if $statefip_global == 13 { 
			*these are Urban Institute (HPC/HIPSM) defined areas, not official GA or census concepts 
			gen area = 0
			replace area = 1 if inlist(rr_num,2)
			replace area = 2 if inlist(rr_num,3)
			replace area = 3 if inlist(rr_num,5)
			replace area = 4 if inlist(rr_num,14)
			replace area = 5 if inlist(rr_num,11,12,16)
			replace area = 6 if inlist(rr_num,1,6,15)
			replace area = 7 if inlist(rr_num,4,8,13)
			replace area = 8 if inlist(rr_num,7,9,10)
			global statename "Georgia"
			label define area 1 "Athens" 2 "Atlanta" 3 "Augusta" 4 "Savannah" 5 "Central" 6 "Southern" 7 "Western" 8 "Northern"
		}
		else if $statefip_global == 37 { 
			*these are Urban Institute (HPC/HIPSM) defined areas, not official NC or census concepts 
			gen area = 0
			replace area = 1 if inlist(puma,3101, 3102, 3103, 3104, 3105, 3106, 3107, 3108, 3200, 3300, 3400, 5300, 5400)
			replace area = 2 if inlist(puma,200, 1801, 1802, 1803, 3500, 1900)
			replace area = 3 if inlist(puma,300, 1701, 1702, 1703, 1704, 3600)
			replace area = 4 if inlist(puma,1301, 1302, 1400, 1500, 1600)
			replace area = 5 if inlist(puma,1100, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208)
			replace area = 6 if inlist(puma,2201, 2202, 2300, 2400, 2500, 2600, 2000, 2100, 2800, 2900, 100, 2700, 3001, 3002)
			replace area = 7 if inlist(puma,3700, 3800, 5001, 5002, 5003, 5100, 5200, 3900, 4100, 4500, 4700, 4800, 4600, 4900)
			replace area = 8 if inlist(puma,400, 500, 600, 700, 900, 1000, 4000, 4200, 800, 4300, 4400)
		
			/* Alternative using rr_num instead of pumas; these are the same groups as above:
			replace area = 1 if inlist(rr_num,4)
			replace area = 2 if inlist(rr_num,6)
			replace area = 3 if inlist(rr_num,7)
			replace area = 4 if inlist(rr_num,11)
			replace area = 5 if inlist(rr_num,13)	
			replace area = 6 if inlist(rr_num,1,2,3,5) //MS rr number 5 (pumas 2700, 3011,3002) was still listed with group 8 here (the by-puma definition was already correct)
			replace area = 7 if inlist(rr_num,8,9,15)
			replace area = 8 if inlist(rr_num,10,12,14,16)
			*/
		
			global statename "North Carolina"
			label define area 1 "Charlotte" 2 "Winston-Salem" 3 "Greensboro" 4 "Durham/Chapel Hill" 5 "Raleigh" 6 "Western" 7 "Southeastern" 8 "Northeastern"    
		}
	
		else{
			pause on
			*display "This state is not yet defined."
			pause This state is not yet defined
			pause off
			FAIL in set_characteristics [SingleStateAreaUninsurance.do]
		}	 
	}		
	
	capture describe race 
	if (_rc == 111) {
		gen byte race = 0
		replace race = 3 if hispan == 0 & racnum == 1 & racwht == 2
		replace race = 2 if hispan != 0 & racamind != 2
		replace race = 1 if hispan == 0 & racnum == 1 & racblk == 2 
		replace race = 4 if hispan == 0 & racnum == 1 & (racpacis == 2|racasian == 2)|racamind == 2|race == 0
		capture label define race 1 "Black, non-hispanic" 2 "Hispanic" 3 "White, non-Hispanic" 4 "Other"
		capture label value race race
	}
	
	capture describe age_group
	if (_rc == 111) {
		gen byte age_group = .
		replace age_group = 1 if age < 19 
		replace age_group = 2 if age > 18 & age < 35 
		replace age_group = 3 if age > 34 & age < 55 
		replace age_group = 4 if age > 54 & age < 65 
		capture label define age_group 1 "0-18" 2 "19-34" 3 "35-54" 4 "55-64"
		capture label value age_group age_group
	}
	
	capture describe age_group_m
	if (_rc == 111) {
		gen byte age_group_m = .
		replace age_group_m = 1 if age < 19 & sex == 1
		replace age_group_m = 2 if age > 18 & age < 35 & sex == 1
		replace age_group_m = 3 if age > 34 & age < 55 & sex == 1
		replace age_group_m = 4 if age > 54 & age < 65 & sex == 1
		capture label define age_group_m 1 "0-18" 2 "19-34" 3 "35-54" 4 "55-64"
		capture label value age_group_m age_group_m
	}

	capture describe age_group_f
	if (_rc == 111) {
		gen byte age_group_f = .
		replace age_group_f = 1 if age < 19 & sex == 2
		replace age_group_f = 2 if age > 18 & age < 35 & sex == 2
		replace age_group_f = 3 if age > 34 & age < 55 & sex == 2
		replace age_group_f = 4 if age > 54 & age < 65 & sex == 2
		capture label define age_group_f 1 "0-18" 2 "19-34" 3 "35-54" 4 "55-64"
		capture label value age_group_f age_group_f
	}
	
	capture describe edu_group
	if (_rc == 111) {
		gen byte edu = .
		replace edu = 1 if educ < 6
		replace edu = 2 if educ == 6 
		replace edu = 3 if inlist(educ, 7,8,9) 
		replace edu = 4 if inlist(educ, 10, 11)  
		capture label drop edu
		capture label define edu 1 "Less than HS" 2 "High School" 3 "Some College" 4 "College Graduate"
		capture label val edu edu
		cap drop edu_group
		bysort tuid_undoc rep_id: gegen edu_group = max(edu)
		capture label drop edu_group
		capture label define edu_group 1 "Less than HS" 2 "High School" 3 "Some College" 4 "College Graduate"
		capture label val edu_group edu_group
	}
	
	capture describe wstat
	if (_rc == 111) {
		gen byte wstat = 0
		replace wstat = 3 if empstat == 1 & uhrswork > 29 
		replace wstat = 2 if empstat == 1 & uhrswork < 30
		replace wstat = 1 if empstat == 0 | empstat == 3
		capture drop num_fulltime
		bysort tuid_undoc rep_id: gegen byte num_fulltime = sum(wstat==3)
		capture drop has_parttime
		bysort tuid_undoc rep_id: gegen byte has_parttime = max(wstat==2)
		capture drop ws
		gen byte ws = 0
		replace ws = 3 if num_fulltime > 1
		replace ws = 3 if num_fulltime == 1
		replace ws = 2 if num_fulltime == 0 & has_parttime
		replace ws = 1 if ws == 0
		capture label define ws 1 "No Worker in Family" 2 "Only Part-Time Worker in family" 3 "At least one Full-Time Worker in family" 
		capture label value ws ws
	}
	
	
	capture describe cat_citizen
	if (_rc == 111) {
	gen cat_citizen = 0
		replace cat_citizen = 1 if inrange(citizen, 0, 2)
		replace cat_citizen = 3 if citizen == 3
		replace cat_citizen = 2 if citizen == 3 & undoc == 1
		capture label drop cat_citizen

		capture label value cat_citizen cat_citizen
	
		cap drop f_cat_citizen has_undoc has_noncitizen
		bysort tuid_undoc rep_id: gegen byte has_undoc = max(undoc == 1)
		bysort tuid_undoc rep_id: gegen byte has_noncitizen = max(citizen == 3)
		gen f_cat_citizen = 0
		replace f_cat_citizen = 2 if has_undoc == 1
		replace f_cat_citizen = 3 if has_undoc == 0 & has_noncitizen == 1
		replace f_cat_citizen = 0 if f_cat_citizen == 0
		capture label drop f_cat_citizen
		capture label define f_cat_citizen 1 "Citizen" 2 "Non-Citizen - Undocumented" 3 "Non-Citizen - Documented"
		capture label value f_cat_citizen f_cat_citizen	
	}
	
end


*In AHCA & BCRA format
*table_C1_areas
*characteristics of uninsured
capture program drop table_C1_areas
program define table_C1_areas

	syntax, weight(string) workbook(string) note(string) year(string) sim_cov_var(string) sim_elig_var(string) sim_cov_label(string) aca_cov_var(string) aca_elig_var(string)
	
	set_characteristics

	label value area area
		
	forvalues area = 1(1)8 {
			preserve  
			local areaname : label area `area'
			
			putexcel set "`workbook'", modify sheet("C1")
			local namerow = 38 + `area'
			putexcel A`namerow' = "`areaname'"
			
			write_index, workbook(`workbook') table("C1_`area'") title("Characteristics of the Uninsured in `areaname' Area")
			global SummaryTableNum = ${SummaryTableNum} + 1
			
			putexcel set "`workbook'", modify sheet("C1_`area'")
			putexcel A1 = "Characteristics of the Uninsured Population and Those Who Would Gain Coverage under Medicaid Expansion in the `areaname', $statename, Area, 2023"
			*putexcel A2 = "Current law (`aca_cov_var') compared with `sim_cov_label' (`sim_cov_var') in 20`year'"
			*putexcel E3 = "Uninsured under `sim_cov_label'"
			putexcel I4 = "HIDE - Subgroup Population under `aca_cov_var'"
			putexcel J4 = "HIDE - Subgroup Population under `sim_cov_var'"
			keep if area == `area'
			
			local rowlist "6 12 18 22 29 34" 
			local chalist "race age_group sex edu_group  f_cat_citizen  ws"
			local n: word count `rowlist'
		
			foreach var in `aca_cov_var' `sim_cov_var' {
				if ("`var'" == "`aca_cov_var'") {
					local col "B"
				}
				else {
					local col "E"
				}
				
				forval i = 1/`n' {
					local cha: word `i' of `chalist'
					local row: word `i' of `rowlist'
					
					if (!inlist("`cha'", "edu_group", "cat_eng")) {
						tab `cha' [iw=`weight'] if age < 65 & `var' == 6, matcell(C1`col'_`row')			
					}
					else {
						tab `cha' [iw=`weight'] if inrange(age, 19, 64) & `var' == 6, matcell(C1`col'_`row')
					}
					putexcel `col'`row' = matrix(C1`col'_`row')	
				}
			}
			
			foreach var in `aca_cov_var' `sim_cov_var' {
				if ("`var'" == "`aca_cov_var'") {
					local col "I"
				}
				else {
					local col "J"
				}
				forval i = 1/`n' {
					local cha: word `i' of `chalist'
					local row: word `i' of `rowlist'
					
					if (!inlist("`cha'", "edu_group", "cat_eng")) {
						tab `cha' [iw=`weight'] if age < 65, matcell(C1`col'_`row'pop)
					}
					else {
						tab `cha' [iw=`weight'] if inrange(age, 19, 64), matcell(C1`col'_`row'pop)
					}
					putexcel `col'`row' = matrix(C1`col'_`row'pop)
				}
			}
		
		
			local yyyy = year(date(c(current_date),"DMY"))
			putexcel A58 = "Source: The Urban Institute. Health Insurance Policy Simulation Model (HIPSM), `yyyy'."
		restore		
}


end

*In AHCA & BCRA format
*table_C1
*characteristics of uninsured

capture program drop table_C1
program define table_C1
	
	syntax, weight(string) workbook(string) note(string) year(string) sim_cov_var(string) sim_elig_var(string) sim_cov_label(string) aca_cov_var(string) aca_elig_var(string)
	
	set_characteristics

	write_index, workbook(`workbook') table("C1") title("Table C1. Impacts of Medicaid Expansion in $statename, by Selected Characteristics and Geographic Area, 2023")
	putexcel set "`workbook'", modify sheet("C1")
	putexcel A1 = "Impacts of Medicaid Expansion in $statename, by Selected Characteristics and Geographic Area, 2023"
	*putexcel A2 = "Current law (`aca_cov_var') compared with `sim_cov_label' (`sim_cov_var') in 20`year'"
	*putexcel E3 = "Uninsured under `sim_cov_label'"
	putexcel I4 = "HIDE - Subgroup Population under `aca_cov_var'"
	putexcel J4 = "HIDE - Subgroup Population under `sim_cov_var'"
	
	
	local rowlist "6 12 18 22 29 34" 
	local chalist "race age_group sex edu_group  f_cat_citizen  ws"
	local n: word count `rowlist'
	
	foreach var in `aca_cov_var' `sim_cov_var' {
		if ("`var'" == "`aca_cov_var'") {
			local col "B"
		}
		else {
			local col "E"
		}
		
		forval i = 1/`n' {
			local cha: word `i' of `chalist'
			local row: word `i' of `rowlist'
			
			if (!inlist("`cha'", "edu_group", "cat_eng")) {
				tab `cha' [iw=`weight'] if age < 65 & `var' == 6, matcell(C1`col'_`row')			
			}
			else {
				tab `cha' [iw=`weight'] if inrange(age, 19, 64) & `var' == 6, matcell(C1`col'_`row')
			}
			putexcel `col'`row' = matrix(C1`col'_`row')	
		}
	}
	
	foreach var in `aca_cov_var' `sim_cov_var' {
		if ("`var'" == "`aca_cov_var'") {
			local col "I"
		}
		else {
			local col "J"
		}
		forval i = 1/`n' {
			local cha: word `i' of `chalist'
			local row: word `i' of `rowlist'
			
			if (!inlist("`cha'", "edu_group", "cat_eng")) {
				tab `cha' [iw=`weight'] if age < 65, matcell(C1`col'_`row'pop)
			}
			else {
				tab `cha' [iw=`weight'] if inrange(age, 19, 64), matcell(C1`col'_`row'pop)
			}
			putexcel `col'`row' = matrix(C1`col'_`row'pop)
		}
	}
	
	local yyyy = year(date(c(current_date),"DMY"))
	putexcel A58 = "Source: The Urban Institute. Health Insurance Policy Simulation Model (HIPSM), `yyyy'." 
	
end	

