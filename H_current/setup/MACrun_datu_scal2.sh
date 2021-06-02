#!/bin/bash
###########################
#
#Scritp that reads parameter file and
#runs a QMC simulation for each parameter
#in the file
#
#CHANGE ALWAYS THE JOB NAME TO BE CAREFUL
#
#When recicling the script: CHANGE VARIABLE AND ARRAY NAMES TO BE EXPLICIT
###########################

#Readibg parameter file
#readarray -t dtau_arr < Hops.dat
dtau_arr=$(awk -F= '{print $1}' dtaus.dat)
echo ${dtau_arr}

jobname="44_current_scal_test"  #JOBNAME importan to declare -has to be descriptive

#General info about the job
date_in="`date "+%Y-%m-%d-%H-%M-%S"`"
echo "${date_in}" >inforun
echo '....Jobs started running' >>  inforun

#Temporary directories where the runs will take place
dire_to_temps="../temp/temp_${jobname}_${date_in}"
rm -rf "${dire_to_temps}"
mkdir "${dire_to_temps}"

#loop over the parameters
for dtau_val in ${dtau_arr[@]}; do

	#create one temporary directory per parameter
	dire=""${dire_to_temps}"/${jobname}_${dtau_val}"
	rm -rf "${dire}"
	mkdir -vp "${dire}"

	#modifying "parameter" file for the specific run
	#and moving everything to the temp directory
	sed "s:Ltau\                 = 1:Ltau\                 = 0:g" parameters > temp_parameters
	sed "s:Dtau      = 0.1d0           ! Thereby Ltrot=Beta/dtau:Dtau      = ${dtau_val}d0           ! Thereby Ltrot=Beta/dtau:g"  temp_parameters > "${dire}"/parameters
	rm temp_parameters
	cp seeds "${dire}"/seeds

done
