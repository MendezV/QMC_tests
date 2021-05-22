#!/bin/bash
readarray -t transverse_hoppings < Hops.dat
for ty in ${transverse_hoppings[@]}; do
	dire="ty_${ty}"
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
	dire="ty_${ty}"
	cd "${dire}"
	/home/juan/Programs/ALF/Scripts_and_Parameters_files/Start/analysis.sh &
	cd ..
	sleep 1 
done


wait
dateman="-`date "+%Y-%m-%d-%H-%M"`"
mkdir "../data/ty_${dateman}"
mv ty* "../data/ty_${dateman}"

