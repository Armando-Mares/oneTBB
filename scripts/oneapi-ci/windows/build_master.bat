@echo on

REM Capture the current working directory
set "WORK_DIR=%CD%"

REM Print it for logging
echo Current working directory: %WORK_DIR%

REM Get the directory of the current script
set SCRIPT_DIR=%~dp0

REM Call each script and pass the working directory as an argument
cmd /c ""%SCRIPT_DIR%setup_dependencies.bat" "%WORK_DIR%""
cmd /c ""%SCRIPT_DIR%build_hwloc.bat" "%WORK_DIR%""
cmd /c ""%SCRIPT_DIR%build_onetbb_gmake.bat" "%WORK_DIR%""
cmd /c ""%SCRIPT_DIR%build_onetbb_msvc.bat" "%WORK_DIR%""
cmd /c ""%SCRIPT_DIR%build_onetbb_sanity_tests.bat" "%WORK_DIR%""
cmd /c ""%SCRIPT_DIR%build_onetbb_tbb4py.bat" "%WORK_DIR%""

REM Create artifacts directory in the current working directory
set "ARTIFACTS_DIR=%WORK_DIR%\artifacts"
if not exist "%ARTIFACTS_DIR%" (
    mkdir "%ARTIFACTS_DIR%"
)


REM Copy all tbb4py tar.bz2 files for different Python versions
copy "%WORK_DIR%\onetbb-ci\conda\win-64\tbb4py-2022.2-py3*_intel_0.tar.bz2" "%ARTIFACTS_DIR%"

REM Copy the gmake and msvc zip artifacts
copy "%WORK_DIR%\onetbb-ci\onetbb_source_code\build_gmake\tbb-2022.2.0-windows_msvc_*.zip" "%ARTIFACTS_DIR%"
copy "%WORK_DIR%\onetbb-ci\onetbb_source_code\build_msvc\tbb-2022.2.0-windowsstore_msvc_*.zip" "%ARTIFACTS_DIR%"

REM Log the contents of the artifacts directory
echo.
echo ===== Contents of the artifacts directory =====
dir "%ARTIFACTS_DIR%"
echo ===============================================
