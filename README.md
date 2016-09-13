# livesys

This is a live system, intended to be run in-memory with a kernel and initramfs built using ubuntu's live-boot.

It is intended for:

* collecting system inventory
* stress testing
* acting as a rescue image
* performing live system installs
* executing arbitrary scripts

# Development

To build the image, you must have docker.

```
./build.sh
```

Once the image is built, you can snapshot it. This requires squashfs-tools

```
./snapshot.sh
```

# Applications

## Arbitrary script execution

Simply specify the path to a script to execute in the ```onboot_script``` kernel parameter. This will be fetched and executed on boot.

You may also pass ```max_uptime```, which accepts time in the same format as the ```shutdown``` command. If a number is passed, it is assumed to be a minute unless otherwise specified.

## Stress testing

There are numerous stress testing suites:

* stress - an overall benchmark suite for CPU and memory
* stressapptest - another benchmark suite for CPU and memory
* cpuburn - a suite for CPU burnin
* gimps (mprime) - a prime number factoring CPU burnin
* sysbench - a system benchmark suite designed to mimic MySQL workloads
* fio - an I/O testing suite

## Swiss-army

* Various helpful commands have been included:
 * ipmitool
 * megacli
 * mdadm
 * lvm
 * ethtool
 * smartmontools
 * supermicro ipmicfg
 * ruby

If you can think of a utility that would be useful, please send a pull request!

A fully functional ubuntu apt package manager is also included, so you can install packages on-the-fly

## System installation

This image may be used to install other live images, by preparing the necessary environment to copy an image onto. Typically, this means formatting disks.

## Testing

+[![Build Status](https://travis-ci.org/Shopify/livesys.svg?branch=master)](https://travis-ci.org/Shopify/livesys)
