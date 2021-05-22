#!/bin/bash
readarray -t transverse_hoppings < Hops.dat
for ty in ${transverse_hoppings[@]}; do
  dire="ty_${ty}"
  rm -rf "${dire}"
  mkdir -vp "${dire}"
  sed "s:ham_Ty\    = 2.d0:ham_Ty\    = ${ty}.d0:g" parameters > "${dire}"/parameters
  cp seeds "${dire}"/seeds
done
