FROM dalehamel/ubuntu-docker-upstart-minimal

ENV DEBIAN_FRONTEND noninteractive

ADD onboot_script.conf /etc/init/onboot_script.conf
ADD ttyS1.conf /etc/init/ttyS1.conf

# Divert initctl temporarily so apt-update can work
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

# Don't invoke rc.d policy scripts
ADD rc.d-policy-stub /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

################ start Install packages ###################
# Do an initial update so we have updated lists for the build
RUN apt-get update

# Get ruby
RUN  echo "deb http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu trusty main" >> /etc/apt/sources.list
RUN gpg --keyserver keyserver.ubuntu.com --recv C3173AA6
RUN apt-get update
RUN apt-get install -y --force-yes ruby2.3 ruby-switch
RUN ruby-switch --set ruby2.3

# Get megacli
RUN curl http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key -o /tmp/megaraid_gpg
RUN apt-key add /tmp/megaraid_gpg
RUN echo 'deb http://hwraid.le-vert.net/ubuntu trusty main' >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y --force-yes megacli

# Install some additional packages to behave more like a standard ubuntu system
RUN apt-get install -y \
  ethtool \
  ipmitool \
  lldpd \
  lvm2 \
  mdadm \
  openssh-server \
  smartmontools \
  vim \
  wget

ADD sysbench /usr/bin/sysbench

RUN chmod +x /usr/bin/sysbench

############### Stress testing tools

RUN wget http://www.mersenne.org/ftp_root/gimps/p95v289.linux64.tar.gz -O /tmp/mprime.tar.gz
RUN tar -xvpf /tmp/mprime.tar.gz -C /tmp
RUN mv /tmp/mprime /usr/bin

RUN apt-get install -y \
  cpuburn \
  fio \
  libmysqlclient18 \
  stress \
  stressapptest

ADD ipmicfg.tar.gz /usr/local/src/ipmicfg/
ADD ipmicfg /usr/bin

RUN chmod +x /usr/bin/ipmicfg

################ Done Install packages ###################


# Undo the diversion so upstart can work
RUN rm /sbin/initctl
RUN dpkg-divert --local --rename --remove /sbin/initctl

# Undo the fake policy-rc.d
RUN rm /usr/sbin/policy-rc.d

# delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*
# this forces "apt-get update" in dependent images, which is also good

# Get rid of this, we don't need it anymore and it'll mess with the real init
RUN rm /etc/init/fake-container-events.conf

CMD ["/sbin/init"]

