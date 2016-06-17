IMAGE="dalehamel/livesys:latest"
OUTPUT="livesys.squashfs"


tmpdir=$(mktemp -d /tmp/livesys-snapXXXXXXX)

echo "Creating container from ${IMAGE}"
container=$(docker run -d ${IMAGE})

echo "Exporting ${container} to ${tmpdir}..."
docker export ${container} | sudo tar -C ${tmpdir} -xpf -

echo "Squashing..."
sudo mksquashfs ${tmpdir} ${OUTPUT} -wildcards -e '.docker*' 'tmp/*' 'usr/src' 'var/lib/apt/lists/archive*' 'var/cache/apt/archives'

echo "Output is at ${OUTPUT}"
sudo chown `whoami` ${OUTPUT}

echo "Cleaning up"
docker rm -f ${container}
sudo rm -rf ${tmpdir}
