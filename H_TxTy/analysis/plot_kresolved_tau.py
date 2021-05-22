#!/usr/bin/python

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
#imaginary time-dependent observables (for ph quantities measurements go until beta/2)


##getting a list with the names of the directories generated after
##error analysis -- also getting the k points from directories titles

#path='/home/juan/Programs/ALF/pyALF/Scripts/ALF_data'
Options=['SpinZ_','SpinXY_','SpinT_','Green_','Den_']
path='/home/juan/Programs/ALF/pyALF/Notebooks/ALF_data/Hubbard_Square/'

filename=path+'get_names.sh'
f=open(filename, 'w')
f.writelines(["#!/bin/bash \n", " ls "+path+" -l | grep '^d'|grep '"+Options[3]+"' | awk '{print $NF}' > temp.tmp"])
f.close()
os.system("chmod u+x "+filename)
os.system("cd "+path+" ;"+"./get_names.sh")

filename=path+'temp.tmp'
f=open(filename, 'r')
lines=[]
for line in f:
    lines.append(line.strip())
    #print(line,'s')

R0=lines.pop()
f.close()
os.system('rm '+path+'get_names.sh')
os.system('rm '+path+'temp.tmp')

#coords from the titles of the directories
pairs= np.array([i.split('_')[1:] for i in lines], dtype=np.float)
xx=pairs[:,0]
yy=pairs[:,1]
x=list(set(list(xx)))
y=list(set(list(yy)))
x.sort()
y.sort()
xpl=[round(i,3) for i in x]
ypl=[round(i,3) for i in y]

NL=int(np.sqrt(np.size(xx)))

#print(lines)
#print(R0)

Obs_T=[]
Err_T=[]
Proxy=[]
Proxy_err=[]
for line in lines:
    filename=path+line+'/g_dat'
    f=open(filename, 'r')

    li=[]
    for lin in f:
        l=[]
        l=[i for i in (lin.strip()).split()]
        li.append(l)
        #print(line,'s')
    #print(li[0])
    #getting the first line which contains general info:
    Nimtimes=int(li[0][0])
    EffectiveNbins=int(li[0][1])
    beta=float(li[0][2])
    Norbitals=int(li[0][3])
    channel=li[0][4]

    #getting the contents of g_dat in array form
    tau=np.array(li[1:], dtype=np.float)[:,0]
    mean=np.array(li[1:], dtype=np.float)[:,1]
    err=np.array(li[1:], dtype=np.float)[:,2]
    Obs_T.append(mean)
    Err_T.append(err)

    ind_half_time=np.where(tau==beta/2)[0][0]
    Proxy.append(mean[ind_half_time])
    Proxy_err.append(err[ind_half_time])

A=np.reshape(np.array(Proxy),[NL,NL])

###plots
Npl=np.arange(NL)
plt.imshow(A)
plt.xticks(Npl,xpl)
plt.yticks(Npl,ypl)
plt.show()
