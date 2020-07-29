CPU_COUNT="$(grep -c ^processor /proc/cpuinfo)"
echo "---Setting compile cores to $CPU_COUNT---"

apt-get update
apt-get install --no-install-recommends zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev libgdbm-dev liblzma-dev tk8.6-dev lzma lzma-dev libgdbm-dev python3-pip libcairo2-dev python3-dev libgirepository1.0-dev python3-cairo-dev libgdbm-compat-dev

cd ${DATA_DIR}
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/python3.8.4rc1.tgz https://www.python.org/ftp/python/3.8.4/Python-3.8.4rc1.tgz

mkdir ${DATA_DIR}/python3.8.4rc1
tar -C ${DATA_DIR}/python3.8.4rc1 --strip-components=1 -xf ${DATA_DIR}/python3.8.4rc1.tgz
cd ${DATA_DIR}/python3.8.4rc1
./configure --prefix=/usr
DESTDIR=${DATA_DIR}/Python3.8.4rc1 make install

pip3 install gobject PyGObject -t ${DATA_DIR}/Python3.8.4rc1/usr/lib/python3.8/site-packages/

mkdir ${DATA_DIR}/Python3.8.4rc1/install
tee ${DATA_DIR}/Python3.8.4rc1/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
python: python (v3.8.4rc1)
python:
python: Custom Python 3.8.4rc1 package for Unraid-Kernel-Helper by ich777
EOF
cd ${DATA_DIR}/Python3.8.4rc1
strip -s ${DATA_DIR}/Python3.8.4rc1/usr/lib/* ${DATA_DIR}/Python3.8.4rc1/usr/bin/*
makepkg ../python-3.8.4rc1-x86_64-1.tgz  # twice NO!

rm -R ${DATA_DIR}/python3.8.4rc1
rm -R${DATA_DIR}/Python3.8.4rc1
rm ${DATA_DIR}/python3.8.4rc1.tgz