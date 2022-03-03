#!/usr/bin/env python -u

import time
from periphery import GPIO
from escpos import *
import cv2
import sys
# https://github.com/vsergeev/python-periphery

"""
1. Wait until everything is ready
2. Wait until button pressed
3. Toggle light on
4. Take photo
5. Toggle light off
6. Print
"""

"""

# Open GPIO /dev/gpiochip0 line 10 with input direction
gpio_in = GPIO("/dev/gpiochip0", 10, "in")
# Open GPIO /dev/gpiochip0 line 12 with output direction
gpio_out = GPIO("/dev/gpiochip0", 12, "out")

value = gpio_in.read()
gpio_out.write(not value)

gpio_in.close()
gpio_out.close()

"""

def print_snapshot():

    # Allow overriding default device
    serialTTY = '/dev/ttyS1'
    if len(sys.argv) > 1:
        serialTTY = sys.argv[1]

    # Capture image from webcam
    camera = cv2.VideoCapture(0)
    return_value, image = camera.read()

    # Rotate and scale
    image = cv2.rotate(image, cv2.ROTATE_90_CLOCKWISE)
    scale_percent = 50 # percent of original size
    width = int(image.shape[1] * scale_percent / 100)
    height = int(image.shape[0] * scale_percent / 100)
    dim = (width, height)
    image = cv2.resize(image,dim)

    # Write to file
    cv2.imwrite('capture.png', image)

    # Initialize printer connection
    p = printer.Serial(devfile=serialTTY,
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



def main():

    # Open GPIO /dev/gpiochip0 line 18 with input direction
    gpio_in = GPIO("/dev/gpiochip0", 18, "in")
    gpio_in.bias = "pull_up"
    print("Photobooth ready, waiting for button press on pin 18")

    try:
        while True:

            # GPIO 18 will be Flase while button is pressed
            if not gpio_in.read():
                print("Button pin " + str(gpio_in.line) + "went low, starting print")
                print_snapshot()
                time.sleep(3)
                print("Print done")
    finally:
        print("Exiting, closing GPIO")
        gpio_in.close()

if __name__=='__main__':
    main()
