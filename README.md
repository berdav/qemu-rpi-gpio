# QEMU RPI GPIO
Simulate GPIO in qemu-based Raspberry Pi

## How it works
The script (`virtual-gpio.py`) present in this repository interacts with qemu 
using the built-in `qtest` protocol.

Wrapping the protocol and interacting with the memory of the guest operating
system, it can set or reset the various GPIOs.

**Note:** Vanilla qemu (5.1.93) will not handle GPIO interrupts, therefore
loading `/sys/class/gpio/gpio$N/direction` and wait for an interrupt
will not do anything.

To enable interrupt support you need to download and compile
[this qemu fork](https://github.com/berdav/qemu).

## Installation
*Wait a little time, I'm pushing to pip :)*

## Prereqisites
You need `socat`, `python3` and `pexpect` library to use this
script.

These can be installed under ubuntu with:
```
sudo apt install python3-pexpect socat
```

To download raspbian images you'll need 7zip
```
sudo apt install p7zip-full
```

## Setup
Download a raspbian image using
```
./setup.sh
```

After this operation, execute the script to load the unix socket and make it
available to qemu
```
./virtual-gpio
```

You will be prompted to an interactive shell, you can find the commands available
in the *Interacting with gpios* section.

In another terminal execute the `./run.sh` script, this will execute a virtual
raspberry pi and attach it to the gpio application.

If you close the raspberry pi you can reload the socket using the command
`reload` in the virtual-gpio prompt.

## Interacting with gpios

First of all, you need to export GPIOs in your guest Linux.
In a shell on your raspberry pi do:
```
$ sudo su -
# echo 4 >/sys/class/gpio/export
# echo in >/sys/class/gpio/direction
```

The main commands in the `virtual-gpio` application are:

| command     | description                             | example |
|-------------|-----------------------------------------|---------|
| `get $N`    | get the value of GPIO $N                | get 4   |
| `set $N $V` | set the value of GPIO $N to $V (1 or 0) | set 4 1 |

You can get the full list of commands using `help`

For instance, let us set the value of the pre-exported gpio 4
```
(gpio)> set 4 1
```

Now you can read the value of your gpio 

```
# cat /sys/class/gpio/value
1
```

If we set it to zero, it will be immediately reflected in the guest system
```
(gpio)> set 4 0
```
```
# cat /sys/class/gpio/value
0
```