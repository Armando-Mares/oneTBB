@echo on

cd C:\work_dir\onetbb-ci\onetbb_source_code
mkdir build
cd build
cmake -G "Visual Studio 16 2019" -A x64 -DCMAKE_BUILD_TYPE=Release ..
cmake --build . --config Release
ctest -C Release
