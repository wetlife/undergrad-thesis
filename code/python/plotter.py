from __future__ import division
import numpy as np
import matplotlib.pyplot as plt
import os

os.chdir('/home/thomasky/Downloads/ph403/thesis/data/numerical')
for file in os.listdir('./'):
    print file, ':'
    time,area,eccentricity = np.loadtxt(file, delimiter=',',unpack=True)
    print "plotting vals:"
    plt.figure(1)
    plt.plot(time,area)
    plt.figure(2)
    plt.plot(time,eccentricity)
plt.figure(1)
plt.xlabel('Time in Minutes', fontsize=20)
plt.ylabel('Area of the Selected Cell in Pixels', fontsize=20)
plt.figure(2)
plt.xlabel('Time in Minutes', fontsize=20)
plt.ylabel('Eccentricity of the Selected Cell', fontsize=20)
plt.show()
