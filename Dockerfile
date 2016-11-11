FROM dalehamel/ubuntu-docker-systemd-minimal

ENV DEBIAN_FRONTEND noninteractive

# Install systemd unit files
ADD init/onboot_script.service /etc/systemd/system/onboot_script.service
ADD init/onboot_script /usr/local/bin/onboot_script
RUN chmod +x /usr/local/bin/onboot_script
RUN systemctl enable onboot_script


ADD init/timed_shutdown.service /etc/systemd/system/timed_shutdown.service
ADD init/timed_shutdown /usr/local/bin/timed_shutdown
RUN chmod +x /usr/local/bin/timed_shutdown
RUN systemctl enable timed_shutdown

# Enable ttyS1 getty for serial console
RUN systemctl enable getty@ttyS1

# Don't invoke rc.d policy scripts
ADD util/rc.d-policy-stub /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

################ start Install packages ###################
# Do an initial update so we have updated lists for the build
RUN apt-get update

# Get ruby
RUN  echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu xenial main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv C3173AA6
RUN apt-get update
RUN apt-get install -y --force-yes ruby2.3 ruby-switch

# Get megacli
RUN curl http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key -o /tmp/megaraid_gpg
RUN apt-key add /tmp/megaraid_gpg
RUN echo 'deb http://hwraid.le-vert.net/ubuntu wily main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes megacli

# Install some additional packages to behave more like a standard ubuntu system
RUN apt-get install -y \
  ethtool \
  ipmitool \
  lldpd \
  lvm2 \
  mdadm \
  net-tools \
  openssh-server \
  smartmontools \
  mysql-common \
  vim \
  wget \
  xfsprogs \
  xz-utils

RUN wget http://launchpadlibrarian.net/212189159/libmysqlclient18_5.6.25-0ubuntu1_amd64.deb
RUN dpkg -i libmysqlclient18_5.6.25-0ubuntu1_amd64.deb
ADD sysbench /usr/bin/sysbench

RUN chmod +x /usr/bin/sysbench

############### Stress testing tools

RUN wget http://www.mersenne.org/ftp_root/gimps/p95v289.linux64.tar.gz -O /tmp/mprime.tar.gz
RUN tar -xvpf /tmp/mprime.tar.gz -C /tmp
RUN mv /tmp/mprime /usr/bin

RUN apt-get install -y \
  cpuburn \
  fio \
  stress \
  stressapptest

ADD ipmi/ipmicfg.tar.gz /usr/local/src/ipmicfg/
ADD ipmi/ipmicfg /usr/bin
ADD ipmi/sum /usr/bin

RUN chmod +x /usr/bin/ipmicfg
RUN chmod +x /usr/bin/sum

################ Done Install packages ###################

RUN useradd -G sudo -m ubuntu
RUN echo ubuntu:ubuntu | chpasswd
ADD etc/sudoers /etc/sudoers

# Undo the fake policy-rc.d
RUN rm /usr/sbin/policy-rc.d

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good

CMD ["/sbin/init"]
