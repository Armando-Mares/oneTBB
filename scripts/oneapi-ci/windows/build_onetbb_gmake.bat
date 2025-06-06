@echo on

REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64
cd "%BASE_DIR%\onetbb-ci\onetbb_source_code"
mkdir build_gmake
cd build_gmake
cmake -G "MinGW Makefiles" ^
    -DCMAKE_MAKE_PROGRAM="C:\localdisk\tools\gmake\latest\gmake.exe" ^
    -DCMAKE_CXX_COMPILER=cl ^
    -DCMAKE_C_COMPILER=cl ^
    -DCMAKE_CXX_STANDARD=14 ^
    -DCMAKE_BUILD_TYPE="relwithdebinfo" ^
    -DTBB_CPF="OFF" ^
    -DCMAKE_HWLOC_STATIC_LIBRARY_PATH="%BASE_DIR%\hwloc-2.9.3\win64\lib\hwloc.lib" ^
    -DCMAKE_HWLOC_STATIC_INCLUDE_PATH="%BASE_DIR%\hwloc-2.9.3\win64\include" ^
    -DCMAKE_HWLOC_2_LIBRARY_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.0.1\lib\libhwloc.lib" ^
    -DCMAKE_HWLOC_2_DLL_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.0.1\bin\libhwloc-15.dll" ^
    -DCMAKE_HWLOC_2_INCLUDE_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.0.1\include" ^
    -DCMAKE_HWLOC_2_5_LIBRARY_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.5.0\lib\libhwloc.lib" ^
    -DCMAKE_HWLOC_2_5_DLL_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.5.0\bin\libhwloc-15.dll" ^
    -DCMAKE_HWLOC_2_5_INCLUDE_PATH="C:\localdisk\tools\hwloc\latest\hwloc-win64-build-2.5.0\include" ^
    -DTBB_TEST=OFF ..
C:\localdisk\tools\gmake\latest\gmake.exe VERBOSE=1
cpack
