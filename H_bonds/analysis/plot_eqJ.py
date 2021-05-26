#!/usr/bin/python

##equal time correlation functions

import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

#path='/home/juan/Programs/ALF/pyALF/Scripts/ALF_data'
Options=['SpinZ_eqJ','SpinXY_eqJ','SpinT_eqJ','Green_eqJ','Den_eqJ']
RK=['R','K']
path='/home/juan/Programs/ALF/pyALF/Notebooks/ALF_data/Hubbard_Square/'

filename=path+Options[-1]+RK[0]
f=open(filename, 'r')

lines=[]
for line in f:
    l=[]
    l=[float(i) for i in (line.strip()).split()]
    lines.append(l)
    #print(line,'s')


##processing coordinates
xx=np.array(lines[::2])[:,0]
yy=np.array(lines[::2])[:,1]
x=list(set(list(np.array(lines[::2])[:,0])))
y=list(set(list(np.array(lines[::2])[:,1])))
x.sort()
y.sort()
xpl=[round(i,3) for i in x]
ypl=[round(i,3) for i in y]

## getting values if the correlation functions
orbsalph=np.array(lines[1::2])[:,0]
orbsbet=np.array(lines[1::2])[:,1]
real=np.array(lines[1::2])[:,2]
realerr=np.array(lines[1::2])[:,3]
im=np.array(lines[1::2])[:,4]
imerr=np.array(lines[1::2])[:,5]


##plots

NL=int(np.sqrt(np.size(xx)))
Npl=np.arange(NL)
imsq=np.reshape(im,[NL,NL])
plt.imshow(imsq)
plt.xticks(Npl,xpl)
plt.yticks(Npl,ypl)
plt.show()

NL=int(np.sqrt(np.size(xx)))
Npl=np.arange(NL)
realsq=np.reshape(real,[NL,NL])
plt.imshow(realsq)
plt.xticks(Npl,xpl)
plt.yticks(Npl,ypl)
plt.show()
