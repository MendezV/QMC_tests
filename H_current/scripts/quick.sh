#!/bin/bash

svar=$( ls | grep "w" | wc -l )
echo $((${svar}))

if [ $((${svar})) -gt $((0)) ]
then
echo asi es "${svar}"
fi
