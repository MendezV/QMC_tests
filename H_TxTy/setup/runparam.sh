#!/bin/bash
points=1

#LOOPS OVER PARAMETERS TO BE TESTED
#FIRST LOOP: LATTICE SIZE
for (( j=$(( $points - 1 )); j>=0; j-- ))
do
#MAKE NEW TEMPORARY DIRECTORIES IN $SCRATCH
tmpdir="tempdir_T_${j}"
rm -rf $tmpdir
mkdir -p $tmpdir

#COPY all code
cp Tsweep_fixedN.py $tmpdir
cp arrfun.h $tmpdir
cp conduct3Nmu.c $tmpdir


#MOVE TO TEMPORARY DIRECTORY
cd "${tmpdir}"
# First index corresponds to density second to potential strenght
python Tsweep_fixedN.py "${j}" 0 > "data${j}.out" &
cd ..
sleep 1
done


## Put all func in the background and bash
## would wait until those are completed
## before displaying all done message
wait
dateman="-`date "+%Y-%m-%d-%H-%M"`"
cat tempdir_T*/data*.out > "../data/Tsweep${dateman}.out"
mkdir "../data/configs/configs${dateman}"
rm tempdir_T*/config.dat
mv tempdir_T*/config* "../data/configs/configs${dateman}"
rm -rf tempdir_T*
echo "All done"
