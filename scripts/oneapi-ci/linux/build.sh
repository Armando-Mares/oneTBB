#!/bin/bash

set -eo pipefail

# Constants
readonly BASE_DIR="$(pwd)"
readonly HWLOC_VERSION="2.9.3"
readonly HWLOC_DIR="$BASE_DIR/hwloc-$HWLOC_VERSION"
readonly INTEL64_DIR="$HWLOC_DIR/intel64"
readonly ZIP_NAME="hwloc-$HWLOC_VERSION-linux.zip"
readonly ONETBB_CI_DIR="$BASE_DIR/onetbb-ci"
readonly LATEST_ZIP_URL="https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/linux/hwloc/latest.zip"

download_and_extract_hwloc() {
  wget "https://download.open-mpi.org/release/hwloc/v2.9/hwloc-$HWLOC_VERSION.tar.gz" -O "$BASE_DIR/hwloc.tar.gz"
  tar -xzf "$BASE_DIR/hwloc.tar.gz" -C "$BASE_DIR"
}

build_hwloc() {
  mkdir -p "$INTEL64_DIR"
  cd "$HWLOC_DIR"
  CXXFLAGS="-fPIC" CFLAGS="-fPIC" LDFLAGS="-fPIC" ./configure \
    --enable-static --disable-io --disable-libxml2 --disable-libudev \
    --disable-cairo --prefix="$INTEL64_DIR"
  make install
}

package_hwloc() {
  cd "$BASE_DIR"
  zip --symlinks -r "$ZIP_NAME" "hwloc-$HWLOC_VERSION/intel64"
  unzip "$BASE_DIR/$ZIP_NAME" -d "$ONETBB_CI_DIR"
}

download_and_extract_latest_hwloc() {
  wget "$LATEST_ZIP_URL" -O "$BASE_DIR/latest.zip"
  unzip "$BASE_DIR/latest.zip" -d "$BASE_DIR"
}

setup_environment() {
  source /opt/intel/oneapi/compiler/latest/env/vars.sh intel64
}

configure_and_build_onetbb() {
  mkdir -p "$ONETBB_CI_DIR/build"
  cd "$ONETBB_CI_DIR/build"

  local HWLOC_STATIC_LIB_PATH
  local HWLOC_STATIC_INCLUDE_PATH
  local HWLOC_2_LIB_PATH
  local HWLOC_2_INCLUDE_PATH
  local HWLOC_25_LIB_PATH
  local HWLOC_25_INCLUDE_PATH

  HWLOC_STATIC_LIB_PATH=$(realpath "$ONETBB_CI_DIR/hwloc-$HWLOC_VERSION/intel64/lib/libhwloc.a")
  HWLOC_STATIC_INCLUDE_PATH=$(realpath "$ONETBB_CI_DIR/hwloc-$HWLOC_VERSION/intel64/include")
  HWLOC_2_LIB_PATH=$(realpath "$BASE_DIR/latest/lib/intel64/hwloc-2.0.1/hwloc/.libs/libhwloc.so.15.0.0")
  HWLOC_2_INCLUDE_PATH=$(realpath "$BASE_DIR/latest/lib/intel64/hwloc-2.0.1/include")
  HWLOC_25_LIB_PATH=$(realpath "$BASE_DIR/latest/lib/intel64/hwloc-2.5.0/hwloc/.libs/libhwloc.so.15.5.0")
  HWLOC_25_INCLUDE_PATH=$(realpath "$BASE_DIR/latest/lib/intel64/hwloc-2.5.0/include")

  cmake -DCMAKE_CXX_COMPILER=icpx -DCMAKE_C_COMPILER=icx \
    -DTBB_TEST=ON \
    -DCMAKE_HWLOC_STATIC_LIBRARY_PATH="$HWLOC_STATIC_LIB_PATH" \
    -DCMAKE_HWLOC_STATIC_INCLUDE_PATH="$HWLOC_STATIC_INCLUDE_PATH" \
    -DCMAKE_HWLOC_2_LIBRARY_PATH="$HWLOC_2_LIB_PATH" \
    -DCMAKE_HWLOC_2_INCLUDE_PATH="$HWLOC_2_INCLUDE_PATH" \
    -DCMAKE_HWLOC_2_5_LIBRARY_PATH="$HWLOC_25_LIB_PATH" \
    -DCMAKE_HWLOC_2_5_INCLUDE_PATH="$HWLOC_25_INCLUDE_PATH" \
    -DCMAKE_BUILD_TYPE=relwithdebinfo \
    -DCMAKE_INSTALL_LIBDIR=lib \
    "$ONETBB_CI_DIR/onetbb_source_code"

  make VERBOSE=1 -j6
  cpack
  ctest -j6
}

build_conda_package() {
  cd "$ONETBB_CI_DIR"
  export TBB_SRC_ROOT=$(realpath "$ONETBB_CI_DIR/onetbb_source_code")
  export ICX_VARS="/opt/intel/oneapi/compiler/latest/env/vars.sh"
  /root/miniforge3/bin/conda-build --old-build-string --no-include-recipe --output-folder conda .github/scripts/conda
  ls conda/linux-64/
  zip -r tbb4py_linux.zip conda/linux-64/tbb4py*bz2
}

copy_artifacts() {
  cd "$BASE_DIR"
  pwd
  local ARTIFACTS_DIR="$BASE_DIR/artifacts"
  mkdir -p "$ARTIFACTS_DIR"

  # Copy tbb4py tarballs
  cp "$ONETBB_CI_DIR/conda/linux-64/tbb4py-2022.2-py3"*"_intel_0.tar.bz2" "$ARTIFACTS_DIR/"

  # Copy tbb zip
  cp "$ONETBB_CI_DIR/build/tbb-2022.2.0-linux_"*".zip" "$ARTIFACTS_DIR/"
}


main() {
  download_and_extract_hwloc
  build_hwloc
  package_hwloc
  download_and_extract_latest_hwloc
  setup_environment
  configure_and_build_onetbb
  build_conda_package
  copy_artifacts
}

main "$@"
