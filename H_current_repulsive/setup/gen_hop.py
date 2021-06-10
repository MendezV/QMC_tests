import numpy as np
tys=np.arange(1,2,1)
f = open("Hops.dat","w")
for t in tys:
	f.write(str(t)+'\n')
f.close()
