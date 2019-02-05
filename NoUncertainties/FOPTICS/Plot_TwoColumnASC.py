# Need to import the plotting package:
import matplotlib.pyplot as plt
import numpy as np
import sys

file_name = open(sys.argv[1],'r')
lines = file_name.readlines()
file_name.close()

#file_name = open(sys.argv[2],'r')
#lines1 = file_name.readlines()
#file_name.close()

# initialize some variable to be lists:
x1 = []
y1 = []

#x2 = []
#y2 = []


# scan the rows of the file stored in lines, and put the values into some variables:
for line in lines:
    p = line.split()
    x1.append(float(p[0]))
    y1.append(float(p[1]))

#for line in lines1:
#    p = line.split()
#    x2.append(float(p[0]))
#    y2.append(float(p[1]))
    
xv = np.array(x1)
yv = np.array(y1)

#xw = np.array(x2)
#yw = np.array(y2)

# now, plot the data:
#plt.plot(xv, yv, 'r', xw, yw, 'b')
plt.plot(xv, yv, 'r')

plt.show()