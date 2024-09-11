import cv2
import numpy
from PIL import Image
import time

#Function definitions
#open the image and return 3 matrices, each corresponding to one channel (R, G and B channels)
def openImage(image):
  imOrig = image
  im = numpy.array(imOrig)
  aRed = im[:, :, 0]
  aGreen = im[:, :, 1]
  aBlue = im[:, :, 2]
  return [aRed, aGreen, aBlue, imOrig]

#compress the matrix of a single channel
def compressSingleChannel(DataMatrix, r):
  U, D, VT = numpy.linalg.svd(DataMatrix)
  D = numpy.diag(D)
  Xapprox = U[:, 0:r] @ D[0:r, 0:r] @ VT[0:r, :]
  Xapprox = Xapprox.astype('uint8')
  return Xapprox

#Creating an object and reading from input file
cap = cv2.VideoCapture('tomnjerry.mp4')
#Getting data of frames per second for the video being input
fps = cap.get(cv2.CAP_PROP_FPS)
print('Frames per second, fps = %.2f '%(fps))
img_array = [] #Empty for storing reduced images
i=0 #Count for number of frames/images
r = int(input('Enter rank approximation: '))
# Check if file is opened successfully
if (cap.isOpened()== False):
  print("Error opening video stream or file")

# Read until video is completed
while(cap.isOpened()):
  # Read frame-by-frame
  ret, frame = cap.read()
  if ret == True:
    aRed, aGreen, aBlue, originalImage = openImage(frame)
    aRedCompressed = compressSingleChannel(aRed, r)
    aGreenCompressed = compressSingleChannel(aGreen, r)
    aBlueCompressed = compressSingleChannel(aBlue, r)
    imr = Image.fromarray(aRedCompressed, mode=None)
    img = Image.fromarray(aGreenCompressed, mode=None)
    imb = Image.fromarray(aBlueCompressed, mode=None)
    newImage = Image.merge("RGB", (imr, img, imb))
    compimage = numpy.array(newImage)
    height, width, layers = compimage.shape
    print ('Still Processing = %d'%(i))
    size = (width, height)
    img_array.append(compimage)
    i += 1
    if cv2.waitKey(25) & 0xFF == ord('q'): #Quit he video
      break
  else:
    break

#Releasing the video capture object
cap.release()

#Writing the images to form compressed video
out = cv2.VideoWriter('tomnjerry_rank'+ str(r) + '.mp4',cv2.VideoWriter_fourcc('m','p','4','v'), fps, size)

for i in range(len(img_array)):
    out.write(img_array[i])
out.release()
print ('*** Video Compression completed!!! ***')
# Closing all the frames
cv2.destroyAllWindows()
