#!/bin/bash
# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2014-2019 Intel Corporation
set -e

SRC_PATH=$1
BUILD_TYPE=$2

if [ -z ${BUILD_TYPE} ] ; then
  BUILD_TYPE=Release
fi
if [ -z ${SRC_PATH} ] ; then
  SRC_PATH=.
fi

pushd $SRC_PATH
rm -rf $BUILD_TYPE
mkdir -p $BUILD_TYPE
pushd $BUILD_TYPE
cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE -DBUILD_TEST=YES -DBUILD_SAMPLES=YES ..
cmake --build . --config $BUILD_TYPE --clean-first --target package
popd
popd

