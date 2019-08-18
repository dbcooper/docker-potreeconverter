FROM debian:stretch-20190812

# PotreeConvert _seems_ to build successfully w/ libboost-dev but
# PotreeConverter's [old] Dockerfile uses libboost-all-dev

RUN apt-get update && \
    apt-get install -y apt-utils build-essential git cmake libboost-all-dev


# Problem is having a consistent version of LAStools ?!  Clone repo maybe?  idk
##RUN cd && git clone https://github.com/LAStools/LAStools.git && \
##        cd LAStools/LASzip &&  \
##        mkdir Release && \
##        cd Release && \
##        cmake -DCMAKE_BUILD_TYPE=Release .. && \
##        make && \
##        make install && \
##        cp -r dll/ /usr/local/

# LAStools puts the LASzip shared library and header files in /usr/local/dll

# Using standalone LASzip instead of full LAStools b/c it has release tags.
# See https://github.com/LASzip/LASzip/releases
RUN cd && git clone https://github.com/LASzip/LASzip.git && \
    cd LASzip && \
    git checkout -b 3.4.1 3.4.1 && \
    mkdir Release && \
    cd Release && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make && \
    make install

# LASzip standalone puts header(s) in /usr/local/include/laszip and
# liblaszip.so.8 in /usr/local/lib .  I set -rpath /usr/local/lib
# options via cmake[3], but it doesn't take

# When cmake builds PotreeConverter, it sets a RUNPATH entry in the executable
# it generates[1] so it can load liblaszip.so from /usr/local/lib.  However,
# the make install step strips the RUNPATH entry from the elf _before_ copying
# into /usr/local/bin[2].  As a result, /usr/local/bin/PotreeConvert doesn't
# search the /usr/local/lib path for the liblaszip.sh library :(
#
# Hence, this kluge
RUN ln -s /usr/local/lib/liblaszip.so.8 /usr/lib/


RUN cd && git clone https://github.com/potree/PotreeConverter.git  && \
    cd PotreeConverter && \
    git checkout -b 1.6 1.6 && \
    mkdir Release && \
    cd Release && \
    cmake -DCMAKE_BUILD_TYPE=Release -DLASZIP_INCLUDE_DIRS=/usr/local/include/laszip -DLASZIP_LIBRARY=/usr/local/lib/liblaszip.so .. && \
    make && \
    make install

# Installs PotreeConverter to /usr/local/bin/

RUN mkdir -p /data/input && \
    mkdir /data/converted

# Copy resources to binary working directories[4]
RUN cd && \
    ln -s ./PotreeConverter/PotreeConverter/resources   /usr/local/bin && \
    ln -s ./PotreeConverter/PotreeConverter/resources   ./PotreeConverter/Release/PotreeConverter && \
    ln -s ./PotreeConverter/PotreeConverter/resources   /data

# Test PotreeConverter, starting from previous command
COPY test.sh  /root/PotreeConverter/Release
RUN  chmod +x /root/PotreeConverter/Release/test.sh

# ----
# [1] readelf -d /root/PotreeConverter/Release/PotreeConverter/PotreeConverter | head -20
# [2] readelf -d /usr/local/bin/PotreeConverter | head -20
# [3] See https://en.wikipedia.org/wiki/Rpath  ,  https://stackoverflow.com/a/30455909/1502174
# [4] Not sure if this means where the executable lives or $PWD when we're running PotreeConverter

