import RPi.GPIO as GPIO
import time
import os
import datetime

def has_subdir_with_suffix(path, suffix):
    for dirpath, dirnames, filenames in os.walk(path):
        for dirname in dirnames:
            if dirname.endswith(suffix):
                return True
    return False

def reset_wire(pin):
    GPIO.setup(pin, GPIO.OUT)
    GPIO.output(pin, GPIO.LOW)
    time.sleep(3)
    GPIO.output(pin, GPIO.HIGH)

def check_for_suffixes(suffixes):
    for pin, suffix in suffixes:
        # reset_wire(pin)
        if not has_subdir_with_suffix("/sys/bus/w1/devices", suffix):
            print(f"{suffix} not found reseting pin {pin}")
            reset_wire(pin)

def program_loop(sensors):
     check_for_suffixes(sensors)
     time.sleep(60)


GPIO.setmode(GPIO.BCM)
sensors = [(17, "032097794d3a"), (17, "01191ef8e4bd")]
# check_for_suffixes(sensors)
program_loop(sensors)

