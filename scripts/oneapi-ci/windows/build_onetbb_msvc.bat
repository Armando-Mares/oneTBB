@echo on

REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Professional\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
cd "%BASE_DIR%\onetbb-ci\onetbb_source_code"
mkdir build_msvc
cd build_msvc
cmake -G "Visual Studio 15 2017" -A x64 ^
    -DCMAKE_CXX_COMPILER=cl ^
    -DCMAKE_C_COMPILER=cl ^
    -DCMAKE_CXX_STANDARD=14 ^
    -DCMAKE_BUILD_TYPE=relwithdebinfo ^
    -DTBB_CPF=OFF ^
    -DTBB_TEST=OFF ^
    -DCMAKE_SYSTEM_NAME:STRING=WindowsStore ^
    -DCMAKE_SYSTEM_VERSION:STRING=10.0 ..
cmake --build . -v --config relwithdebinfo -j 8
cpack -C relwithdebinfo
