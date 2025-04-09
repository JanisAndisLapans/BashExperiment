#!/bin/bash

# install and compile 3.1.0.
wget "https://github.com/htop-dev/htop/archive/refs/tags/3.1.0.tar.gz"
tar -xvzf 3.1.0.tar.gz
cd "htop-3.1.0"
./autogen.sh
./configure --prefix=/usr/local/htop310
make -j$(nproc)
make install

# add to path
echo 'export PATH="$PATH:/usr/local/htop310/bin"' >> ~/.bashrc
source ~/.bashrc
