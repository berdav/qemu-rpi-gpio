#!/usr/bin/env python3
from distutils.core import setup
import setuptools

with open("README.md") as f:
    description = f.read()

setup(
    name             = 'qemu-rpi-gpio',
    scripts          = [ "qemu-rpi-gpio" ],
    version          = '0.4',
    license          = 'GPLv3',
    description      = 'Simulate GPIOs in qemu-based Raspberry PI',
    long_description = description,
    long_description_content_type='text/markdown',
    author           = 'Davide Berardi',
    author_email     = 'berardi.dav@gmail.com',
    url              = 'https://github.com/berdav/qemu-rpi-gpio',
    download_url     = 'https://github.com/berdav/qemu-rpi-gpio/archive/refs/tags/v0.4.zip',
    keywords         = [ 'raspberry-pi', 'gpio', 'virtualization', 'qemu' ],
    install_requires = [
        'pexpect'
    ],
    classifiers      = [
        'Development Status :: 3 - Alpha',
        'Environment :: Console',
        'Intended Audience :: Education',
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Topic :: Software Development :: Embedded Systems',
        'Topic :: Software Development :: Testing :: Mocking',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.4',
        'Programming Language :: Python :: 3.5',
        'Programming Language :: Python :: 3.6',
        'Programming Language :: Python :: 3.7',
        'Programming Language :: Python :: 3.8',
        'Programming Language :: Python :: 3.9',
        'Programming Language :: Python :: 3.10',
    ]
)
