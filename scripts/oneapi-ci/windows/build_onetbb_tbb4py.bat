@echo on

REM Get the passed working directory
set "BASE_DIR=%~1"

REM Print it for logging
echo Current working directory: "BASE_DIR=%~1"

set VARS_MINICONDA3_WINDOWS=C:\tools\Miniforge3\Scripts\activate
set TBB_SRC_ROOT=%BASE_DIR%\onetbb-ci\onetbb_source_code
set CONDA_RECIPES_DIR=%BASE_DIR%\onetbb-ci\.github\scripts\conda
set CONDA_OUTPUT_DIR=%BASE_DIR%\onetbb-ci\conda

cmd /c "%BASE_DIR%\onetbb-ci\.github\scripts\conda\windows_build.bat %CONDA_RECIPES_DIR% %CONDA_OUTPUT_DIR% %VARS_MINICONDA3_WINDOWS%"
