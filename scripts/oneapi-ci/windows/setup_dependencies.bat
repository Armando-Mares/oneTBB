@echo on


REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

REM Create necessary directories
mkdir C:\localdisk\tools\gmake
mkdir C:\localdisk\tools\hwloc

REM Download and extract hwloc tarball
curl -O https://download.open-mpi.org/release/hwloc/v2.9/hwloc-2.9.3.tar.gz
"C:\Program Files\7-Zip\7z.exe" x %BASE_DIR%\hwloc-2.9.3.tar.gz -so | "C:\Program Files\7-Zip\7z.exe" x -aoa -si -ttar -o"%BASE_DIR%"

REM Download and extract gmake zip
curl -o %BASE_DIR%\gmake_latest.zip https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/windows/gmake/latest.zip
"C:\Program Files\7-Zip\7z.exe" x %BASE_DIR%\gmake_latest.zip -o"C:\localdisk\tools\gmake"

REM Download and extract hwloc zip
curl -o %BASE_DIR%\hwloc_latest.zip https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/windows/hwloc/latest.zip
"C:\Program Files\7-Zip\7z.exe" x %BASE_DIR%\hwloc_latest.zip -o"C:\localdisk\tools\hwloc"

echo Dependencies downloaded and extracted successfully.
