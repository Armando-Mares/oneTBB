@echo on

set VARS_MINICONDA3_WINDOWS=C:\tools\Miniforge3\Scripts\activate
set TBB_SRC_ROOT=C:\work_dir\onetbb-ci\onetbb_source_code
set CONDA_RECIPES_DIR=C:\work_dir\onetbb-ci\.github\scripts\conda
set CONDA_OUTPUT_DIR=C:\work_dir\onetbb-ci\conda

cmd /c "C:\work_dir\onetbb-ci\.github\scripts\conda\windows_build.bat %CONDA_RECIPES_DIR% %CONDA_OUTPUT_DIR% %VARS_MINICONDA3_WINDOWS%"
