import numpy as np
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import sys, time, math, re
import serial

xsize=500

def data_gen():
    t = data_gen.t
    while True:
		t+=1
		val=ser.readline()
		print val
		val=re.sub("[^0-9\\.,]", "", val)
		vals=re.split(",",val)
		fil.write(str(val) + '\n')
		yield t, vals
def run(data):
    # update the data
    t,y = data
    if t>-1:
		xdata.append(t)
		ydata.append(y[0])
		xdata2.append(t)
		ydata2.append(y[1])
		if t>xsize: # Scroll to the left.
			ax.set_xlim(t-xsize, t)
		line.set_data(xdata, ydata)
		line2.set_data(xdata2, ydata2)
		
    return [line,line2]

def on_close_figure(event):
    sys.exit(0)
	
# configure the serial port	
ser = serial.Serial(
	port='COM19',
	baudrate=57600,
	parity=serial.PARITY_NONE,
	stopbits=serial.STOPBITS_TWO,
	bytesize=serial.EIGHTBITS
)
ser.isOpen()

fil = open('C:\Users\Jason\Documents\GitHub\EECE281\Proj1\logfile.txt', 'a')
data_gen.t = -1
fig = plt.figure()
fig.canvas.mpl_connect('close_event', on_close_figure)
ax = fig.add_subplot(111)
line, = ax.plot([], [], lw=2)
line2, = ax.plot([], [], lw=2)
ax.set_ylim(0, 256)
ax.set_xlim(0, xsize)
ax.grid()
xdata, ydata, xdata2, ydata2 = [], [], [], []
# Important: Although blit=True makes graphing faster, we need blit=False to prevent
# spurious lines to appear when resizing the stripchart.
ani = animation.FuncAnimation(fig, run, data_gen, blit=False, interval=100, repeat=False)
plt.show()

#while 1:
#	strin = re.sub("[^0-9\.]", "", ser.readline())
#	print strin