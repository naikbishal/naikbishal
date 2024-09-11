import numpy
from PIL import Image
import matplotlib.pyplot as plt

#Function definitions
#open the image and return 3 matrices, each corresponding to one channel (R, G and B channels)
def openImage(imagePath):
    imOrig = Image.open(imagePath)
    im = numpy.array(imOrig)
    aRed = im[:, :, 0]
    aGreen = im[:, :, 1]
    aBlue = im[:, :, 2]
    print ('Number of singular values for the image = %d'%(len(aRed)))
    return [aRed, aGreen, aBlue, imOrig]

#compress the matrix of a single channel
def compressSingleChannel(DataMatrix, r):
    U, D, VT = numpy.linalg.svd(DataMatrix)
    D = numpy.diag(D)
    Xapprox = U[:, 0:r] @ D[0:r, 0:r] @ VT[0:r, :]
    cumsum = numpy.cumsum(numpy.diag(D))/numpy.sum(numpy.diag(D))
    Xapprox = Xapprox.astype('uint8')
    return [ Xapprox, cumsum, D]

# MAIN PROGRAM:
filefirstname = input('Enter filename without extension: ')
fileformat = input('Enter extension: ')
filename = filefirstname + fileformat
aRed, aGreen, aBlue, originalImage = openImage(filename)
r = int(input("Enter approximation rank: "))
print('*** Image Compression using SVD ***') #number of singular values to use for compressed image

aRedCompressed, cumsumred, diagred= compressSingleChannel(aRed, r) #Compression of red channel
aGreenCompressed, cumsumgreen, diaggreen = compressSingleChannel(aGreen, r) #Compression of green channel
aBlueCompressed, cumsumblue, diagblue = compressSingleChannel(aBlue, r) #Compression of blue channel

plt.figure(1)
plt.plot((cumsumblue+cumsumred+cumsumgreen)/3,'k-o') #Plotting the graph for Cumulative energy vs Singular values
plt.xlabel('r')
plt.ylabel("Cumulative Energy")
plt.title(r'Singular Values: Cumulative sum')
plt.show()

plt.figure(2)
plt.semilogy(numpy.diag(diagred+diaggreen+diagblue),'k-o') #Plotting the graph for Number of singular values
plt.xlabel('r')
plt.ylabel(r"$\Sigma_{k=1}^{r}\sigma_k$")
plt.title('Singular Values')
plt.show()

imr = Image.fromarray(aRedCompressed, mode=None)
img = Image.fromarray(aGreenCompressed, mode=None)
imb = Image.fromarray(aBlueCompressed, mode=None)

newImage = Image.merge("RGB", (imr, img, imb))
newImage.save(filefirstname + '_rank' + str(r) + fileformat)
print('Displaying original image: ')
originalImage.show()

print('Displaying compressed image: ')
newImage.show()
