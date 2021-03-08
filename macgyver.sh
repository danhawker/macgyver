#!/bin/bash

#set -x

#CONFIG="./macgyver.conf"
CONFIG="/macgyver/macgyver.conf"
if [ ! -f ${CONFIG} ]; then
  echo "Config file ${CONFIG} does not exist"
  exit 2
fi
# source the config
. ${CONFIG}

echo "NICS Defined/Discovered: ${MACGYVER_NICS}"
#echo "ETHTOOL: ${ETHTOOL_OPTS}"

# Inspired by the ETHTOOL_OPTS setup in RHEL NetworkManager
apply_ethtool() {
    # capture existing IFS
    oldifs=$IFS;
    # iterate over NICS
    for nic in ${MACGYVER_NICS} ; do
      echo "NIC: $nic"
      # set IFS to ; for ETHTOOL_OPTS standard
      IFS=';'
      # iterate over the set ethtool options
      for opt in $ETHTOOL_OPTS ; do
        # use simple pattern substitution to splice in the NIC name
        opt="${opt/DEVICE/$nic}"
        echo "APPLYING: /sbin/ethtool $opt"
        /sbin/ethtool $opt
      done
    done

    IFS=$oldifs;
}

echo "Applying ETHTOOL Options..."
apply_ethtool

# EOF
