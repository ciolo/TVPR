import numpy as np
from openni import openni2 
import png


path = "../../Top-view-TVPR/"
prefix = "g0"

def number2string(num):
	if( num < 10 ):
		return '0000'+str(num)
	if( num < 100 ):
		return '000'+str(num)
	if( num < 1000 ):
		return '00'+str(num)
	if( num < 10000 ):
		return '0'+str(num)
	return str(num)

def print_frame(frame_data, index):
	#in frame are values in mm from 8 to 3500 (range of camere): we need to renormalize
    img  = np.frombuffer(frame_data, np.uint16)
    img.shape = (480, 640, 1)
    
    imgMatrix = np.zeros((480, 640))

    for i in range(480):
    	for j in range(640):
    		imgMatrix[i][j] = img[i][j]

    max = 3500
    min = 0

    imgMatrix = imgMatrix/max*2**16

    png.from_array(imgMatrix.astype(np.uint16), "L").save("../../img/"+filename+"/frame"+number2string(index)+".png")

for i in range(17, 23):
	filename = prefix + str(i)
	openni2.initialize()
	dev = openni2.Device(path+filename+".oni")
	print dev.get_device_info()

	depth_stream = dev.create_depth_stream()
	total_frames = depth_stream.get_number_of_frames()
	print "total frames: "+str(total_frames)

	for i in range(total_frames):
		depth_stream.start()
		frame = depth_stream.read_frame()
		depth_stream.stop()
		frame_data = frame.get_buffer_as_uint16()
		print_frame(frame_data, i)

	openni2.unload()