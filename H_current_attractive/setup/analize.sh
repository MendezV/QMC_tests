#!/bin/bash
###########################
#
#Scritp that reads parameter file and
#runs a QMC simulation for each parameter
#in the file
#
#
###########################

#Readibg parameter file
#readarray -t Beta_arr < Hops.dat
Beta_arr=$(awk -F= '{print $1}' Betas.dat)
jobname="88_betasweeps"  #JOBNAME importan to declare -has to be descriptive

#Temporary directories where the runs will take place
dire_to_temps="../temp/temp_88_betasweeps_2021-06-03-14-37-54"

#Loop over parameters to carry out statistical analysis
for Beta_val in ${Beta_arr[@]}; do

	dire=""${dire_to_temps}"/${jobname}_${Beta_val}"
	cd "${dire}"
	pwd
	/home/juan/Programs/ALF/Scripts_and_Parameters_files/Start/analysis.sh &
	cd "../../../setup"
	sleep 1

done


wait

#general info about the job as it ends
date_fin="`date "+%Y-%m-%d-%H-%M-%S"`"
echo "${date_fin}" >>inforun
echo 'Jobs finished running'>>inforun

#moving files to the data directory and tidying up
dire_to_data="../data/${jobname}_${date_fin}"
mkdir "${dire_to_data}"
mv "${dire_to_temps}"/* "${dire_to_data}"
mv inforun "${dire_to_data}"
rm -r "${dire_to_temps}"
