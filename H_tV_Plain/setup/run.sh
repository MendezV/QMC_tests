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
#readarray -t transverse_hoppings < Hops.dat
transverse_hoppings=$(awk -F= '{print $1}' Hops.dat)
echo ${transverse_hoppings}
jobname="StafusaLHVO_tV_L1_28_L2_1_V"  #JOBNAME importan to declare -has to be descriptive

#General info about the job
date_in="`date "+%Y-%m-%d-%H-%M-%S"`"
echo "${date_in}" >inforun
echo '....Jobs started running' >>  inforun

#Temporary directories where the runs will take place
dire_to_temps="../temp/temp_${jobname}_${date_in}"
rm -rf "${dire_to_temps}"
mkdir "${dire_to_temps}"

#loop over the parameters
for ty in ${transverse_hoppings[@]}; do

	#create one temporary directory per parameter
	dire=""${dire_to_temps}"/${jobname}_${ty}"
	rm -rf "${dire}"
	mkdir -vp "${dire}"

	#modifying "parameter" file for the specific run
	#and moving everything to the temp directory
	sed "s:ham_Vint     = 4.d0:ham_Vint\    = ${ty}d0:g" parameters > "${dire}"/parameters
	cp seeds "${dire}"/seeds

	#entering the temp directory, running and coming back
	cd "${dire}"
	/home/juan/Programs/ALF/Prog/ALF.out &
	cd "../../../setup"
	sleep 1

done

wait

#Loop over parameters to carry out statistical analysis
for ty in ${transverse_hoppings[@]}; do

	dire=""${dire_to_temps}"/${jobname}_${ty}"
	cd "${dire}"
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
