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
