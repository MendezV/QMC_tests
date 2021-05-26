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
vars=$(awk -F= '{print $1}' Hops.dat)


Npars=${#vars[@]}


echo ${vars}
