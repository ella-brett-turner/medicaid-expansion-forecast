clear

***Create DisplayRegionPUMA.dta***
cd F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\
use hrr.dta
keep statefip puma rr_num
gen DisplayRegion = .
save DisplayRegionPUMA, replace

merge m:1 statefip DisplayRegion using f:\centers\hpc\hipsm\model\data\ratingregions\DisplayRegions.dta
keep if _merge == 1
keep DisplayRegion statefip puma rr_num
save DisplayRegionPUMA, replace

***Add DisplayRegion codes for selected states***
*Georgia
replace DisplayRegion = 1 if inlist(rr_num,2) & statefip == 13
replace DisplayRegion = 2 if inlist(rr_num,3) & statefip == 13
replace DisplayRegion = 3 if inlist(rr_num,5) & statefip == 13
replace DisplayRegion = 4 if inlist(rr_num,14) & statefip == 13
replace DisplayRegion = 5 if inlist(rr_num,11,12,16) & statefip == 13
replace DisplayRegion = 6 if inlist(rr_num,1,6,15) & statefip == 13
replace DisplayRegion = 7 if inlist(rr_num,4,8,13) & statefip == 13
replace DisplayRegion = 8 if inlist(rr_num,7,9,10) & statefip == 13

*North Carolina
*3500 listed twice
replace DisplayRegion = 1 if inlist(puma,3101, 3102, 3103, 3104, 3105, 3106, 3107, 3108, 3200, 3300, 3400, 5300, 5400) & statefip == 37
replace DisplayRegion = 2 if inlist(puma,200, 1801, 1802, 1803, 3500, 1900)& statefip == 37
replace DisplayRegion = 3 if inlist(puma,300, 1701, 1702, 1703, 1704, 3600)& statefip == 37
replace DisplayRegion = 4 if inlist(puma,1301, 1302, 1400, 1500, 1600)& statefip == 37
replace DisplayRegion = 5 if inlist(puma,1100, 1201, 1202, 1203, 1204, 1205, 1206, 1207, 1208) & statefip == 37
replace DisplayRegion = 6 if inlist(puma,2201, 2202, 2300, 2400, 2500, 2600, 2000, 2100, 2800, 2900, 100, 2700, 3001, 3002)& statefip == 37
replace DisplayRegion = 7 if inlist(puma,3700, 3800, 5001, 5002, 5003, 5100, 5200, 3900, 4100, 4500, 4700, 4800, 4600, 4900)& statefip == 37
replace DisplayRegion = 8 if inlist(puma,400, 500, 600, 700, 900, 1000, 4000, 4200, 800, 4300, 4400)& statefip == 37

*Virginia
replace DisplayRegion = 1 if inlist(puma, 1301,1302, 51255) & statefip == 51
replace DisplayRegion = 2 if inlist(puma, 59301,59302,59303,59304,59305,59306,59307,59308,59309) & statefip == 51
replace DisplayRegion = 3 if inlist(puma, 51115, 51120, 51244,51245,51246) & statefip == 51
replace DisplayRegion = 4 if inlist(puma, 51084, 51085) & statefip == 51
replace DisplayRegion = 5 if inlist(puma, 51125, 51206) & statefip == 51
replace DisplayRegion = 6 if inlist(puma, 10701,10702,10703) & statefip == 51
replace DisplayRegion = 7 if inlist(puma, 51087,51089,51090) & statefip == 51
replace DisplayRegion = 8 if inlist(puma, 4101,4102,4103, 51215,51224,51225,51235) & statefip == 51
replace DisplayRegion = 9 if inlist(puma, 51044,51045, 51080, 51110) & statefip == 51
replace DisplayRegion = 10 if inlist(puma, 51095,51096,51097,51105, 51135) & statefip == 51
replace DisplayRegion = 11 if inlist(puma, 51020, 51040, 51010) & statefip == 51
replace DisplayRegion = 12 if inlist(puma, 51145,51154,51155,51164,51165,51167, 55001,55002) & statefip == 51
replace DisplayRegion = 13 if inlist(puma, 51175, 51186) & statefip == 51
 
*Pennsylvania
replace DisplayRegion = 1 if inrange(puma, 101,102) & statefip == 42 
replace DisplayRegion = 2 if inrange(puma, 701,702) & statefip == 42 
replace  DisplayRegion = 3 if inrange(puma, 801,803) & statefip == 42
replace  DisplayRegion = 5 if (inrange(puma, 1701,1702) | inrange(puma, 1801, 1807)) & statefip == 42
replace  DisplayRegion = 6 if inrange(puma, 2001,2003) & statefip == 42 
replace  DisplayRegion = 7 if inrange(puma, 2701,2703) & statefip == 42 
replace  DisplayRegion = 8 if inrange(puma, 3001,3004) & statefip == 42
replace  DisplayRegion = 9 if inrange(puma, 3101,3106) & statefip == 42
 
replace  DisplayRegion = 10 if inrange(puma, 3201,3211) & statefip == 42
replace  DisplayRegion = 11 if inrange(puma, 3301,3304) & statefip == 42
replace  DisplayRegion = 12 if inrange(puma, 3401,3404) & statefip == 42
replace  DisplayRegion = 13 if inrange(puma, 3501,3504) & statefip == 42
replace  DisplayRegion = 14 if inrange(puma, 3601,3603) & statefip == 42
replace  DisplayRegion = 15 if (inrange(puma, 3701,4002) | inrange(puma,2100,2200)) & statefip == 42
 
replace  DisplayRegion = 16 if (inrange(puma, 200,300) | puma == 1300)   & statefip == 42
replace  DisplayRegion = 17 if inrange(puma, 400,600)   & statefip == 42 
replace  DisplayRegion  = 18 if inrange(puma, 900, 1200) & statefip == 42
 
replace  DisplayRegion  = 19 if (inrange(puma, 1400, 1600)| puma == 1900) & statefip == 42
replace  DisplayRegion  = 20 if inrange(puma, 2301, 2500) & statefip == 42
replace  DisplayRegion  = 21 if (inrange(puma, 2801, 2902) | puma == 2600) & statefip == 42

*Massachusetts
/*replace DisplayRegion = 1 if inlist(puma, 04700,04800) & statefip == 25
replace DisplayRegion = 2 if inlist(puma, 00100, 00200, 01600, 01900,01901, 01902)& statefip == 25
replace DisplayRegion = 3 if (puma==04000 & u_region < .75) | inlist(puma, 04200,04301,04302,04303,04500,04901, 03900, 04902, 04903)& statefip == 25
replace DisplayRegion = 4 if inlist(puma, 00701,00702,00703,00704,01000,01300,02800)& statefip == 25
replace DisplayRegion = 5 if (puma==00400 & u_region > .654) | (puma==01400 & u_region < .958) | (puma==02400 & u_region < .39) | (puma==03400 & u_region < .592) | (puma==03500 & u_region > .731) | inlist(puma, 00501, 00502, 00503, 00504, 00505, 00506, 00507, 00508, 01000, 01300, 02800)& statefip == 25
replace DisplayRegion = 6 if (puma==02400 & u_region > .717) | (puma==03400 & u_region > .592) | (puma==03500 & u_region < .731) | (puma==04000 & u_region > .75) | inlist(puma, 03601, 03602, 03603, 03900, 04200)& statefip == 25
replace DisplayRegion = 7 if inlist(puma, 03301,03302,03303,03304,03305,03306)& statefip == 25
replace DisplayRegion = 8 if (puma==00400 & u_region <= .654) | (puma==01400 & u_region > .958) | (puma==02400 & inrange(u_region,.39,.717)) | inlist(puma, 00300, 00301, 00302, 00303, 00304)& statefip == 25
*/

*New Mexico
replace DisplayRegion = 1 if inrange(puma, 00801, 00806) & statefip == 35
replace DisplayRegion = 2 if puma == 100 & statefip == 35
replace DisplayRegion = 3 if puma == 200 & statefip == 35
replace DisplayRegion = 4 if puma == 300 & statefip == 35
replace DisplayRegion = 5 if puma == 400 & statefip == 35
replace DisplayRegion = 6 if puma == 500 & statefip == 35
replace DisplayRegion = 7 if puma == 600 & statefip == 35
replace DisplayRegion = 8 if puma == 700 & statefip == 35
replace DisplayRegion = 9 if puma == 900 & statefip == 35
replace DisplayRegion = 10 if inlist(puma,1001,1002) & statefip == 35
replace DisplayRegion = 11 if puma == 1100 & statefip == 35
replace DisplayRegion = 12 if puma == 1200 & statefip == 35

*New York
replace DisplayRegion = 1 if puma == 300 & statefip == 36
replace DisplayRegion = 1 if inrange(puma, 1600,2100) & statefip == 36
replace DisplayRegion = 2 if inrange(puma, 1000,1207)& statefip == 36
replace DisplayRegion = 2 if inlist(puma, 2500,2600) & statefip == 36
replace DisplayRegion = 3 if inrange(puma, 2701, 2903)& statefip == 36
replace DisplayRegion = 3 if puma == 2203 & statefip == 36
replace DisplayRegion = 3 if puma == 3101 & statefip == 36
replace DisplayRegion = 4 if inrange(puma,3001,3003)& statefip == 36
replace DisplayRegion = 4 if inrange(puma,3102,3107)& statefip == 36
replace DisplayRegion = 4 if inrange(puma,3701,4114)& statefip == 36
replace DisplayRegion = 5 if inrange(puma,800,906)& statefip == 36
replace DisplayRegion = 5 if inrange(puma,1300,1400)& statefip == 36
replace DisplayRegion = 6 if inrange(puma,701,704)& statefip == 36
replace DisplayRegion = 6 if puma ==1500 & statefip == 36
replace DisplayRegion = 6 if inrange(puma,2201,2202)& statefip == 36
replace DisplayRegion = 6 if inrange(puma,2300,2402)& statefip == 36
replace DisplayRegion = 7 if inrange(puma,100,200)& statefip == 36
replace DisplayRegion = 7 if inrange(puma,401,600)& statefip == 36
replace DisplayRegion = 8 if inrange(puma,3201,3313)& statefip == 36


*Oregon
replace DisplayRegion = 1 if statefip == 41
replace DisplayRegion = 2 if inlist(puma, 01316, 01317, 01308, 1318,1319) & statefip == 41
replace DisplayRegion = 3 if inlist(puma, 01301, 01302, 01303, 01305, 01314) & statefip == 41
replace DisplayRegion = 4 if inlist(puma, 01105, 01103, 01104, 01200) & statefip == 41
replace DisplayRegion= 5 if inlist(puma, 00500, 00600, 00705, 00703, 00704) & statefip == 41
replace DisplayRegion = 6 if inlist(puma, 01000, 00800, 00901, 00902) & statefip == 41
replace DisplayRegion = 7 if inlist(puma, 00200,00100,00300,00400) & statefip == 41

save "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegionPUMA.dta", replace 	

*Texas
use "F:\Centers\HPC\HIPSM\Code_EBT\Sheets\DisplayRegions_scratch_work\cnty puma"
rename state statefip
*Not sure what to do about rr_num or DisplayRegion
gen rr_num = .
rename county DisplayRegion
keep statefip puma DisplayRegion rr_num

*Drop duplicates for Texas
sort statefip puma DisplayRegion 
quietly by statefip puma DisplayRegion: gen dup = cond(_N==1,0,_n)
drop if dup > 1
drop dup

save "F:\Centers\HPC\HIPSM\Code_EBT\Sheets\DisplayRegions_scratch_work\cnty puma_edit.dta", replace

use "f:\centers\hpc\hipsm\model\data\ratingregions\DisplayRegionPUMA.dta"
merge m:m statefip puma using "F:\Centers\HPC\HIPSM\Code_EBT\Sheets\DisplayRegions_scratch_work\cnty puma_edit", update
drop _merge

gen GEOID = (statefip * 100000) + puma

save "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegionPUMA.dta", replace	

*Merge with DisplayRegions 
merge m:1 statefip DisplayRegion using "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegions.dta"

keep if _merge == 3
drop _merge

save "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegion_merged.dta", replace	

stop

*Drop duplicates for DisplayRegionPUMA
sort statefip puma DisplayRegion
quietly by statefip puma DisplayRegion: gen dup = cond(_N==1,0,_n)
drop if dup > 1
drop dup

stop

***Checking DisplayRegionPUMA is correct***

do "F:\Centers\HPC\HIPSM\Model\Programs\data_handling.do"

*Use assemble_data to add in puma
assemble_data, year(23) additional_vars(puma)

*Merge in r_coverage_MRB
merge m:1  ID rep_id using "F:\Centers\HPC\HIPSM\Model\Data\r_Coverage_MRB", keepusing(cov_OEP22Rep_2023) 
keep if _merge == 3
drop _merge

*Merge with earlier file
merge m:1  puma statefip using "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegionPUMA"
keep if _merge == 3
drop _merge

*Save merged file
*save "F:\Centers\HPC\HIPSM\Model\Data\RatingRegions\DisplayRegionPUMA_merged.dta"
tab DisplayRegion [iw=perwt] if cov_OEP22Rep_2023 == 6 & statefip == 13 & age < 65
tab DisplayRegion [iw=perwt] if cov_OEP22Rep_2023 == 6 & statefip == 37 & age < 65 

tab DisplayRegion [iw=perwt] if cov_OEP22ARPA_2023_1 == 6 & statefip== 13 & age < 65
tab DisplayRegion [iw=perwt] if cov_OEP22ARPA_2023_1 == 6 & statefip == 37 & age < 65 

tab DisplayRegion [iw=perwt] if cov_OEP22ARPAllExp2_2023== 6 & statefip== 13 & age < 65
tab DisplayRegion [iw=perwt] if cov_OEP22ARPAllExp2_2023  == 6 & statefip == 37 & age < 65 

tab DisplayRegion [iw=perwt] if ACADefaultCosts2022== 6 & statefip== 13 & age < 65
tab DisplayRegion [iw=perwt] if ACADefaultCosts2022 == 6 & statefip == 37 & age < 65 

