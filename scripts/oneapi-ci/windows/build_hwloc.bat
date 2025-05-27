@echo on

REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64
cd "%BASE_DIR%\hwloc-2.9.3\contrib\windows-cmake"
cmake -G "Visual Studio 16 2019" -A x64 ^
    --install-prefix "%BASE_DIR%\hwloc-2.9.3\win64" ^
    -B "%BASE_DIR%\hwloc-2.9.3\build_win64" ^
    -DHWLOC_ENABLE_TESTING=OFF ^
    -DHWLOC_SKIP_TOOLS=ON ^
    -DHWLOC_WITH_LIBXML2=OFF ^
    -DBUILD_SHARED_LIBS=OFF
cmake --build "%BASE_DIR%\hwloc-2.9.3\build_win64" --config Release --parallel
cmake --install "%BASE_DIR%\hwloc-2.9.3\build_win64" --config Release
cd "%BASE_DIR%"
