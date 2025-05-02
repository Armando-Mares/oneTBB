@echo on

REM Create necessary directories
mkdir C:\localdisk\tools\gmake
mkdir C:\localdisk\tools\hwloc

REM Download and extract hwloc tarball
curl -O https://download.open-mpi.org/release/hwloc/v2.9/hwloc-2.9.3.tar.gz
"C:\Program Files\7-Zip\7z.exe" x C:\work_dir\hwloc-2.9.3.tar.gz -so | "C:\Program Files\7-Zip\7z.exe" x -aoa -si -ttar -o"C:\work_dir\"

REM Download and extract gmake zip
curl -o C:\work_dir\gmake_latest.zip https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/windows/gmake/latest.zip
"C:\Program Files\7-Zip\7z.exe" x C:\work_dir\gmake_latest.zip -o"C:\localdisk\tools\gmake"

REM Download and extract hwloc zip
curl -o C:\work_dir\hwlow_latest.zip https://af01p-igk.devtools.intel.com/artifactory/threadingbuildingblocks-igk-local/tools/windows/hwloc/latest.zip
"C:\Program Files\7-Zip\7z.exe" x C:\work_dir\hwlow_latest.zip -o"C:\localdisk\tools\hwloc"

echo Dependencies downloaded and extracted successfully.
