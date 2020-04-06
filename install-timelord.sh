
THE_PATH=`python -c 'import pkg_resources; print( pkg_resources.get_distribution("chiavdf").location)' 2> /dev/null`/vdf_client
CHIAVDF_VERSION=`python -c 'from setup import dependencies; t = [_ for _ in dependencies if _.startswith("chiavdf")][0]; print(t)'`


install_debian_requirements() {
  local UBUNTU_BUILD_REQUIREMENTS=(cmake libgmp-dev libboost-python-dev libbost-system-dev)
  for packages in "${UBUNTU_BUILD_REQUIREMENTS[@]}"; do
    if [ ! dpkg -s $packages >/dev/null 2>&1; then
      sudo apt-get install $packages -y
    fi
  done
}

if [ `uname` = "Linux" ] && type apt-get;
  then UBUNTU_DEBIAN=1
fi

echo "This script assumes it is run from the chia venv - '. ./activate' before running."



if [ -e $THE_PATH ]
then
  echo $THE_PATH
  echo "vdf_client already exists, no action taken"
else
  if [ -e venv/bin/python && $UBUNTU_DEBIAN ]
  then
    echo "installing chiavdf from source on Ubuntu/Debian"
    # Check for development tools
    install_debian_requirements
    echo venv/bin/python -m pip install --force --no-binary chiavdf $CHIAVDF_VERSION
    venv/bin/python -m pip install --force --no-binary chiavdf $CHIAVDF_VERSION
  else
    echo "no venv created yet, please run install.sh"
  fi
fi
