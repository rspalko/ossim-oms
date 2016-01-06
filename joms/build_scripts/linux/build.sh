#!/bin/bash
pushd `dirname $0` >/dev/null
export SCRIPT_DIR=`pwd -P`

pushd $SCRIPT_DIR/../.. >/dev/null
export JOMS_HOME=$PWD
echo "@@@@@ SCRIPT_DIR=$SCRIPT_DIR"
echo "@@@@@ JOMS_HOME=$JOMS_HOME"

pushd $JOMS_HOME/../.. >/dev/null
export OSSIM_DEV_HOME=$PWD
export OSSIM_HOME=$OSSIM_DEV_HOME/ossim
export OSSIM_BUILD_DIR=$OSSIM_DEV_HOME/build
export OSSIM_BUILD_TYPE=""
popd >/dev/null

popd >/dev/null


pushd $JOMS_HOME > /dev/null
if [ ! -a local.properties ]
   then 
   cp local.properties.template local.properties
fi

if [ -z "$GROOVY_HOME" ]; then
   source "$HOME/.sdkman/bin/sdkman-init.sh"
   if [ ! -z "$GROOVY_VERSION" ]; then
      sdk use groovy $GROOVY_VERSION
   fi
fi

ant clean dist mvn-install
antReturnCode=$?
if [ $antReturnCode -ne 0 ];then
    echo "BUILD ERROR: ant failed dist mvn-install build..."
    exit 1;
else
    exit 0;
fi

if [ ! -z "$OSSIM_INSTALL_PREFIX" ]; then
   ant install
   antReturnCode=$?
fi 
 
popd >/dev/null

#
popd >/dev/null

if [ $antReturnCode -ne 0 ];then
    echo "BUILD ERROR: ant failed install..."
    exit 1;
else
    exit 0;
fi
