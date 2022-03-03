#!/usr/bin/env python

import time
from periphery import GPIO
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


while True:

    # Open GPIO /dev/gpiochip0 line 10 with input direction
    gpio_in = GPIO("/dev/gpiochip0", 10, "in")
    value = gpio_in.read()

    print("Value of pin 18: " + value)

    gpio_in.close()
    time.sleep(3)



