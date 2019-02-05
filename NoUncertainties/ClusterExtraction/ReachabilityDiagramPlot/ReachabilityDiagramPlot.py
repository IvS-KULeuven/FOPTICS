import matplotlib.pyplot as plt
import numpy as np
import sys
from pylab import rcParams

file = open(sys.argv[1], 'r')
lines = file.readlines()

order = []
distance = []
### For plotting clusters with different colours ###
x1 = []
y1 = []
x2 = []
y2 = []
x3 = []
y3 = []
#x4 = []
#y4 = []
#x5 = []
#y5 = []
#x6 = []
#y6 = []
#x7 = []
#y7 = []
#i = 0

for line in lines:
	line = line.strip()
	columns = line.split()
	order.append(int(columns[0]))
	distance.append(float(columns[4]))
### For plotting clusters with different colours ###
#	i = i + 1
#	if i > 0 and i <= 69:
#		x1.append(int(columns[0]))
#		y1.append(float(columns[4]))
#	if i >= 69 and i <= 120:
#		x2.append(int(columns[0]))
#		y2.append(float(columns[4]))
#	if i >= 72 and i <= 75:
#		x3.append(int(columns[0]))
#		y3.append(float(columns[4]))
#	elif i >= 1000 and i <= 1200:
#		x4.append(int(columns[0]))
#		y4.append(float(columns[4]))
#	elif i >= 2300 and i <= 2500:
#		x5.append(int(columns[0]))
#		y5.append(float(columns[4]))
#	elif i > 1200 and i <= 2200:
#		x6.append(int(columns[0]))
#		y6.append(float(columns[4]))
#	elif i >= 500 and i <= 1000:
#		x7.append(int(columns[0]))
#		y7.append(float(columns[4]))

rcParams['figure.figsize'] = 15, 12
plt.fill_between(order, 0, distance, color='black')
plt.xlabel('Order', fontsize=38, labelpad=15)
plt.ylabel(r'$D_r$', fontsize=38, labelpad=15)
plt.tick_params(axis='both', labelsize=38, pad=15.5)

### For plotting clusters with different colours ###
#jet= plt.get_cmap('jet')
#colors = iter(jet(np.linspace(0,1,3)))
#plt.fill_between(x1, 0, y1, color=next(colors)) # facecolor='red'
#plt.fill_between(x2, 0, y2, color=next(colors))
#color = next(colors)
#plt.fill_between(x3, 0, y3, color=(0.85, 0.0, 0.0))
#plt.fill_between(x4, 0, y4, color=next(colors)) # facecolor='red'
#plt.fill_between(x5, 0, y5, color=next(colors)) # facecolor='red'
#plt.fill_between(x6, 0, y6, color=next(colors)) # facecolor='red'
#plt.fill_between(x7, 0, y7, color=next(colors)) # facecolor='red'

#plt.xlim(0.,1700)
#plt.xticks(np.arange(0, 1700.1, 400))
plt.ylim(0.00,0.2)
#plt.yticks(np.arange(271000, 296100, 5000))

plt.tight_layout()
plt.show()
#plt.savefig('ReachabilityDiagram_1D.pdf')