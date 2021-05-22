#!/bin/bash
readarray -t transverse_hoppings < Hops.dat
jobname="ty_Lx_14_Ly_2"
mkdir "../temp/temp_${jobname}"
date "+%Y-%m-%d-%H-%M-%S" >inforun
echo '....Jobs started running' >>  inforun 

for ty in ${transverse_hoppings[@]}; do
	dire="../temp/temp_${jobname}/${jobname}_${ty}"
	rm -rf "${dire}"
	mkdir -vp "${dire}"
	sed "s:ham_Ty\    = 2.d0:ham_Ty\    = ${ty}.d0:g" parameters > "${dire}"/parameters
	cp seeds "${dire}"/seeds
	
	cd "${dire}"
	/home/juan/Programs/ALF/Prog/ALF.out &
	cd ..
	sleep 1
done

wait

for ty in ${transverse_hoppings[@]}; do
	dire="../temp/temp_${jobname}/${jobname}_${ty}"
	cd "${dire}"
	/home/juan/Programs/ALF/Scripts_and_Parameters_files/Start/analysis.sh &
	cd ..
	sleep 1 
done


wait
dateman="-`date "+%Y-%m-%d-%H-%M-%S"`"
echo "${dateman}" >>inforun
echo 'Jobs finished running'>>inforun
mkdir "../data/${jobname}_${dateman}"
mv "${jobname}"* "../data/${jobname}_${dateman}"

