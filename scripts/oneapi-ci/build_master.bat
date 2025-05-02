@echo on

REM Get the directory of the current script
set SCRIPT_DIR=%~dp0

cmd /c "%SCRIPT_DIR%setup_dependencies.bat"
cmd /c "%SCRIPT_DIR%build_hwloc.bat"
cmd /c "%SCRIPT_DIR%build_onetbb_gmake.bat"
cmd /c "%SCRIPT_DIR%build_onetbb_msvc.bat"
cmd /c "%SCRIPT_DIR%build_onetbb_sanity_tests.bat"
cmd /c "%SCRIPT_DIR%build_onetbb_tbb4py.bat"
