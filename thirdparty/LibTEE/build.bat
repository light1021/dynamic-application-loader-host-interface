rem SPDX-License-Identifier: Apache-2.0
rem Copyright (C) 2014-2019 Intel Corporation

set SRC_PATH=%1
set BUILD_TYPE=%2
set BUILD_ARCH=%3

@if "%BUILD_TYPE%"=="" set BUILD_TYPE=Release
@if "%BUILD_ARCH%"=="" set BUILD_ARCH=Win32

rem ================ VS2017 Env =====================
@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat"

pushd $SRC_PATH
@RD /S /Q %BUILD_TYPE%%BUILD_ARCH%
mkdir %BUILD_TYPE%%BUILD_ARCH%
pushd %BUILD_TYPE%%BUILD_ARCH%
cmake -G "Visual Studio 15 2017" -A %BUILD_ARCH% -DCMAKE_SYSTEM_VERSION=10.0 -DBUILD_TEST=YES -DBUILD_SAMPLES=YES ..
cmake --build . --config %BUILD_TYPE% --clean-first --target package
popd
popd