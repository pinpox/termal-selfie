from escpos import *
import cv2

# Capture image from webcam
camera = cv2.VideoCapture(0)
return_value, image = camera.read()

# Rotate and scale
image = cv2.rotate(image, cv2.cv2.ROTATE_90_CLOCKWISE)
scale_percent = 50 # percent of original size
width = int(image.shape[1] * scale_percent / 100)
height = int(image.shape[0] * scale_percent / 100)
dim = (width, height)
image = cv2.resize(image,dim)

# Write to file
cv2.imwrite('capture.png', image)

# Initialize printer connection
p = printer.Serial(devfile='/dev/ttyUSB0',
           baudrate=9600,
           bytesize=8,
           parity='N',
           stopbits=1,
           timeout=1.00,
           dsrdtr=True)

# def set(self, align='left', font='a', text_type='normal', width=1, height=1, density=9, invert=False, smooth=False, flip=False):

# Print text and image
p.set(align='center')
# p.text("text\n")
p.image("capture.png", impl="bitImageColumn", high_density_vertical=False, high_density_horizontal = False)
p.text("\npinpox 2022\n")

# p.qr("You can readme from your smartphone")
p.cut()
