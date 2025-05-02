@echo on

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Auxiliary\Build\vcvarsall.bat" x64
cd C:\work_dir\onetbb-ci\onetbb_source_code
cmake -G "Visual Studio 16 2019" -A x64 ^
    --install-prefix "C:\work_dir\hwloc-2.9.3\win64" ^
    -B "C:\work_dir\hwloc-2.9.3\build_win64" ^
    -DHWLOC_ENABLE_TESTING=OFF ^
    -DHWLOC_SKIP_TOOLS=ON ^
    -DHWLOC_WITH_LIBXML2=OFF ^
    -DBUILD_SHARED_LIBS=OFF
cmake --build "C:\work_dir\hwloc-2.9.3\build_win64" --config Release --parallel
cmake --install "C:\work_dir\hwloc-2.9.3\build_win64" --config Release
cd C:\work_dir
