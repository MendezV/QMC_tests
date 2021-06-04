import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import os
import sys


#path='/home/juan/Programs/ALF/pyALF/Scripts/ALF_data'
Options=['SpinZ_tauJ','SpinXY_tauJ','SpinT_tauJ','Green_tauJ','Den_tauJ','Current_tauJ']
Options2=['Kin_scalJ','Ener_scalJ','Kin_X_scalJ','Part_scalJ', 'Pot_scalJ']
RK=['R','K']
LATSZ=[2,4,6,8,10]
path_pr='/Users/jfmv/Documents/Proyectos/QMC_tests/H_current_attractive/data/'
#path_pr='/home/juan/Documents/Projects/QMC_tests/H_current_attractive/data/'
diri=sys.argv[1]
print(diri[:-19])
path_pr=path_pr+diri+'/'+diri[:-19]

val_list=[]
err_list=[]
sign_list=[]
errsign_list=[]
rhos=[]

for i in LATSZ:

    path=path_pr+str(i)+'/'

    ####################################
    ###################################
    ##################################
    #Scalar observables
    ###############################
    ###############################
    ###############################

    filename=path+Options2[2]
    f=open(filename, 'r')

    lines=[]
    for line in f:
        l=[]
        l=[i for i in (line.strip()).split()]
        lines.append(l)
        #print(line,'s')


    val=float(lines[2][3])
    val_err=float(lines[2][4])
    sign=float(lines[4][3])
    errsign=float(lines[4][4])

    val_list.append(val)
    err_list.append(val_err)
    sign_list.append(sign)
    errsign_list.append(errsign)

    print(val,val_err,sign,errsign)


    ############################
    ###########################
    ############################
    #Current Correlation Function
    ###############################
    #############################
    ###########################

    filename=path+Options[-1]+RK[1]
    f=open(filename, 'r')

    lines=[]
    for line in f:
        l=[]
        l=[float(i) for i in (line.strip()).split()]
        lines.append(l)
        #print(line,'s')

    ##processing coordinates
    xx=np.array(lines)[:,0]
    yy=np.array(lines)[:,1]
    x=list(set(list(np.array(lines)[:,0])))
    y=list(set(list(np.array(lines)[:,1])))
    x.sort()
    y.sort()
    xpl=[round(i,2) for i in x]
    ypl=[round(i,2) for i in y]

    ## getting values if the correlation functions
    real=np.array(lines)[:,2]
    realerr=np.array(lines)[:,3]
    im=np.array(lines)[:,4]
    imerr=np.array(lines)[:,5]

    ###########################
    ###########################
    ##plots
    ##########################
    ##########################


    ###############################
    #real part
    print("Real...",8,"x",8,"...beta=",i)
    NL=int(np.sqrt(np.size(xx)))
    Npl=np.arange(NL)
    realsq=np.reshape(real,[NL,NL])
    realerrsq=np.reshape(realerr,[NL,NL])
    #plt.imshow(realsq.T)
    #plt.xticks(Npl,xpl)
    #plt.yticks(Npl,ypl)
    #plt.xlabel(r"$x$")
    #plt.ylabel(r"$y$")
    #plt.show()

    init=int(NL/2 )
    i_tr=int(NL/2 -1)
    print('kx...',xpl[i_tr])
    #realsq[i_tr,init]=-val
    #realerrsq[i_tr,init]=val_err
    #plt.errorbar(np.array(ypl[init:])*6/(2*np.pi),realsq[i_tr,init:],realerrsq[i_tr,init:], fmt='o-', label=r"$\beta=$"+str(i))
    #plt.errorbar(0,-val, val_err, fmt='o')
    #plt.scatter(0,-val)
    rhos.append(-val-realsq[i_tr,init])
    print("Ds", i,-val-realsq[i_tr,init], np.sqrt(val_err**2 +realerrsq[i_tr,init]))
#plt.ylim([0,1.5])
#plt.legend(fontsize=15,ncol=2)
#plt.xlim([-0.2,4.2])
#plt.xlabel(r"$q_y N_y /2\pi$", size=20)
#plt.show()
