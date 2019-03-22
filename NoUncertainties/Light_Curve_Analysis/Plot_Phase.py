# Need to import the plotting package:
import matplotlib.pyplot as plt
import numpy as np
import sys
from pylab import rcParams

file_name = open(sys.argv[1],'r')
lines = file_name.readlines()
file_name.close()

# initialize some variable to be lists:
x1 = []
y1 = []

# scan the rows of the file stored in lines, and put the values into some variables:
for line in lines:
    p = line.split()
    x1.append(float(p[0]))
    y1.append(float(p[1]))

# now, plot the data:
rcParams['figure.figsize'] = 15, 12    
plt.plot(x1, y1, 'ks',markersize=5)
plt.xlabel('time (days)', fontsize=48, labelpad=15)
plt.ylabel(r'$\Delta$ mag', fontsize=48, labelpad=15)
plt.tick_params(axis='both', labelsize=48, pad=15.5)
#plt.ylim(0.2,-0.005)
#plt.xlim(10,40)
#plt.xticks(np.arange(10, 40.1, 5))

file_name = open(sys.argv[2],'r')
lines = file_name.readlines()
file_name.close()

# initialize some variable to be lists:
x1 = []
y1 = []

# scan the rows of the file stored in lines, and put the values into some variables:
for line in lines:
    p = line.split()
    x1.append(float(p[0]))
    y1.append(float(p[1]))

plt.plot(x1, y1, 'ro',markersize=5)

plt.tight_layout()
plt.show()
#plt.savefig('gammaDor.pdf')