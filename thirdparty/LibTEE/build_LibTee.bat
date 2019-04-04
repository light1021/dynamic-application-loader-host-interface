@REM SPDX-License-Identifier: Apache-2.0
@REM Copyright (C) 2014-2019 Intel Corporation
@REM - Build metee
@echo off

SETLOCAL


SET LIB_OUTDIR=ME_TEE
SET OSBUILD=%1
echo on

rem ================ VS2017 Env =====================
@call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\Common7\Tools\VsDevCmd.bat"

rem ================ Output dir =====================

rmdir /Q /S %LIB_OUTDIR%
mkdir %LIB_OUTDIR%
mkdir %LIB_OUTDIR%\Release\
mkdir %LIB_OUTDIR%\Debug\

rem ================ RELEASE - Make MeTee =====================
set BUILD_TYPE=Release
set BUILD_ARCH=x64
if [%CI_BUILD%]==[1] (
	rem =================BUILD CI MeTee TEST=======================
	set BUILD_TEST=Yes
) else (
	set BUILD_TEST=No
)
call :BUILDONE
if errorlevel 1 goto BUILDFAILED

set BUILD_TEST=No

set BUILD_TYPE=Release
set BUILD_ARCH=Win32
call :BUILDONE
if errorlevel 1 goto BUILDFAILED

rem ================ DEBUG - Make MeTee  =====================
set BUILD_TYPE=Debug
set BUILD_ARCH=x64
call :BUILDONE
if errorlevel 1 goto BUILDFAILED

set BUILD_TYPE=Debug
set BUILD_ARCH=Win32
call :BUILDONE
if errorlevel 1 goto BUILDFAILED


rem  ================ Add MeTee files to ZIP file ================
"c:\Program Files\Winzip\WZZIP.EXE" -P -r MeTee.zip %LIB_OUTDIR%
if errorlevel 1 goto BUILDFAILED

goto ENDBUILD

:BUILDFAILED
Echo !!!! MeTee Lib Building For %OSBUILD% Failed!!!!
exit /B 1

:ENDBUILD
Echo MeTee Lib Building For %OSBUILD% Finished Successfully!
exit /B 0 

:BUILDONE
rmdir /Q /S %BUILD_TYPE%%BUILD_ARCH%
mkdir %BUILD_TYPE%%BUILD_ARCH%
pushd %BUILD_TYPE%%BUILD_ARCH%
if [%BUILD_TEST%]==[Yes] (
	cmake -G "Visual Studio 15 2017" -DCMAKE_SYSTEM_VERSION=10.0 -A %BUILD_ARCH% -DBUILD_TEST=YES ..
) else (
	cmake -G "Visual Studio 15 2017" -DCMAKE_SYSTEM_VERSION=10.0 -A %BUILD_ARCH% ..
)
if errorlevel 1 goto BUILDONEFAILED
cmake --build . --config %BUILD_TYPE% --target package
if errorlevel 1 goto BUILDONEFAILED

copy metee-*.zip ..\%LIB_OUTDIR%\%BUILD_TYPE%
if [%BUILD_TEST%]==[Yes] (
	copy tests\Release\metee_test.exe ..\%LIB_OUTDIR%\
)

popd
exit /B 0
:BUILDONEFAILED
exit /B 1

ENDLOCAL