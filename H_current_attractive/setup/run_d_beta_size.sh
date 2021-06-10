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
lattsizes=$(awk -F= '{print $1}' LxLy.dat)
jobname="88_mu015_nsweeps_20"  #JOBNAME importan to declare -has to be descriptive

#General info about the job
date_in="`date "+%Y-%m-%d-%H-%M-%S"`"
echo "${date_in}" >inforun
echo '....Jobs started running' >>  inforun

#Temporary directories where the runs will take place
dire_to_temps="../temp/temp_${jobname}_${date_in}"
rm -rf "${dire_to_temps}"
mkdir "${dire_to_temps}"

#loop over the parameters
for Lat_L in ${lattsizes[@]}; do
	for Beta_val in ${Beta_arr[@]}; do

		#create one temporary directory per parameter
		dire=""${dire_to_temps}"/${jobname}_${Beta_val}_${Lat_L}"
		rm -rf "${dire}"
		mkdir -vp "${dire}"

		#modifying "parameter" file for the specific run
		#and moving everything to the temp directory
		sed "s:L1           = 4           ! Length in direction a_1:L1           = ${Lat_L}           ! Length in direction a_1:g" parameters > temp_parameters
		sed "s:L2           = 4           ! Length in direction a_2:L2           = ${Lat_L}            ! Length in direction a_2:g"  temp_parameters > temp_parameters2
		sed "s:Beta      = 5.d0            ! Inverse temperature:Beta      = ${Beta_val}d0            ! Inverse temperature:g" temp_parameters2 > "${dire}"/parameters
		rm temp_parameters
		rm temp_parameters2
		cp seeds "${dire}"/seeds

		#entering the temp directory, running and coming back
		cd "${dire}"
		#time /home/juan/Programs/ALF/Prog/ALF.out &
		time /Users/jfmv/Programs/ALF/Prog/ALF.out &
		cd "../../../setup"
		sleep 1

	done
done

wait

#Loop over parameters to carry out statistical analysis
for Lat_L in ${lattsizes[@]}; do
	for Beta_val in ${Beta_arr[@]}; do

		dire=""${dire_to_temps}"/${jobname}_${Beta_val}_${Lat_L}"
		cd "${dire}"
		#/home/juan/Programs/ALF/Scripts_and_Parameters_files/Start/analysis.sh &
		/Users/jfmv/Programs/ALF/Scripts_and_Parameters_files/Start/analysis.sh &
		cd "../../../setup"
		sleep 1

	done
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
