$Env:CONDA_EXE = "/mnt/ramdisk/tools/miniconda/3/amd64/bin/conda"
$Env:_CE_M = ""
$Env:_CE_CONDA = ""
$Env:_CONDA_ROOT = "/mnt/ramdisk/tools/miniconda/3/amd64"
$Env:_CONDA_EXE = "/mnt/ramdisk/tools/miniconda/3/amd64/bin/conda"

Import-Module "$Env:_CONDA_ROOT\shell\condabin\Conda.psm1"
Add-CondaEnvironmentToPrompt