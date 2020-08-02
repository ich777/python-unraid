CPU_COUNT="$(grep -c ^processor /proc/cpuinfo)"
PYTHON_V="3.8.4rc1"
echo "---Setting compile cores to $CPU_COUNT---"

apt-get update
apt-get install --no-install-recommends zlib1g-dev libbz2-dev liblzma-dev libncurses5-dev libreadline6-dev libsqlite3-dev libssl-dev libgdbm-dev liblzma-dev tk8.6-dev lzma lzma-dev libgdbm-dev python3-pip libcairo2-dev python3-dev libgirepository1.0-dev python3-cairo-dev libgdbm-compat-dev

cd ${DATA_DIR}
wget -q -nc --show-progress --progress=bar:force:noscroll -O ${DATA_DIR}/python$PYTHON_V.tgz https://www.python.org/ftp/python/3.8.4/Python-3.8.4rc1.tgz

mkdir ${DATA_DIR}/python$PYTHON_V
tar -C ${DATA_DIR}/python$PYTHON_V --strip-components=1 -xf ${DATA_DIR}/python$PYTHON_V.tgz
cd ${DATA_DIR}/python$PYTHON_V
./configure --prefix=/usr
make -j${CPU_COUNT}
DESTDIR=${DATA_DIR}/Python$PYTHON_V make install

pip3 install gobject PyGObject -t ${DATA_DIR}/Python$PYTHON_V/usr/lib/python3.8/site-packages/

mkdir ${DATA_DIR}/Python$PYTHON_V/install
tee ${DATA_DIR}/Python$PYTHON_V/install/slack-desc <<EOF
       |-----handy-ruler------------------------------------------------------|
python: python (v$PYTHON_V)
python:
python: Custom Python $PYTHON_V package for Unraid-Kernel-Helper by ich777
EOF
cd ${DATA_DIR}/Python$PYTHON_V
strip -s ${DATA_DIR}/Python$PYTHON_V/usr/lib/* ${DATA_DIR}/Python$PYTHON_V/usr/bin/*
makepkg ../python-$PYTHON_V-x86_64-1.tgz  # twice NO!

rm -R ${DATA_DIR}/python$PYTHON_V
rm -R${DATA_DIR}/Python$PYTHON_V
rm ${DATA_DIR}/python$PYTHON_V.tgz