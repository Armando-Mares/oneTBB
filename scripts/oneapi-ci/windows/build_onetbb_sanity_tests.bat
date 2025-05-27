@echo on

REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

cd "%BASE_DIR%\onetbb-ci\onetbb_source_code"
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
ctest -C Release
