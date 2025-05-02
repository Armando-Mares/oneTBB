#!/bin/bash

wget https://download.open-mpi.org/release/hwloc/v2.9/hwloc-2.9.3.tar.gz -O hwloc.tar.gz
tar -xzf hwloc.tar.gz

mkdir hwloc-2.9.3/intel64

#Build 64-bit version
cd hwloc-2.9.3

CXXFLAGS="-fPIC" CFLAGS="-fPIC" LDFLAGS="-fPIC" ./configure --enable-static --disable-io --disable-libxml2 --disable-libudev --disable-cairo --prefix /onetbb-ci/hwloc-2.9.3/intel64
make install

cd ..

zip --symlinks -r hwloc-2.9.3-linux.zip hwloc-2.9.3/intel64

unzip /hwloc-2.9.3-linux.zip

wget https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/linux/hwloc/latest.zip
unzip latest.zip

source /opt/intel/oneapi/compiler/latest/env/vars.sh intel64

mkdir build
cd build

# Determine the absolute paths
HWLOC_STATIC_LIB_PATH=$(realpath ../hwloc-2.9.3/intel64/lib/libhwloc.a)
HWLOC_STATIC_INCLUDE_PATH=$(realpath ../hwloc-2.9.3/intel64/include)
HWLOC_2_LIB_PATH=$(realpath ../latest/lib/intel64/hwloc-2.0.1/hwloc/.libs/libhwloc.so.15.0.0)
HWLOC_2_INCLUDE_PATH=$(realpath ../latest/lib/intel64/hwloc-2.0.1/include)
HWLOC_25_LIB_PATH=$(realpath ../latest/lib/intel64/hwloc-2.5.0/hwloc/.libs/libhwloc.so.15.5.0)
HWLOC_25_INCLUDE_PATH=$(realpath ../latest/lib/intel64/hwloc-2.5.0/include)

# Run CMake with absolute paths
cmake -DCMAKE_CXX_COMPILER=icpx -DCMAKE_C_COMPILER=icx  -DTBB_TEST=ON  -DCMAKE_HWLOC_STATIC_LIBRARY_PATH=$HWLOC_STATIC_LIB_PATH  -DCMAKE_HWLOC_STATIC_INCLUDE_PATH=$HWLOC_STATIC_INCLUDE_PATH  -DCMAKE_HWLOC_2_LIBRARY_PATH=$HWLOC_2_LIB_PATH  -DCMAKE_HWLOC_2_INCLUDE_PATH=$HWLOC_2_INCLUDE_PATH  -DCMAKE_HWLOC_2_5_LIBRARY_PATH=$HWLOC_25_LIB_PATH  -DCMAKE_HWLOC_2_5_INCLUDE_PATH=$HWLOC_25_INCLUDE_PATH  -DCMAKE_BUILD_TYPE=relwithdebinfo  -DCMAKE_INSTALL_LIBDIR=lib  ../onetbb_source_code
make VERBOSE=1 -j6

cpack

ctest -j6

cd ..

ONETBB_SRC_PATH=$(realpath onetbb_source_code)
export TBB_SRC_ROOT=$ONETBB_SRC_PATH
export ICX_VARS=/opt/intel/oneapi/compiler/latest/env/vars.sh

/root/miniforge3/bin/conda-build --old-build-string --no-include-recipe --output-folder conda .github/scripts/conda

ls conda/linux-64/

zip -r tbb4py_linux.zip conda/linux-64/tbb4py*bz2
