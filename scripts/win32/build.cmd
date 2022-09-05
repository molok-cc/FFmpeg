set TRIPLET=%1

set MSYS2_PATH_TYPE=inherit

call "C:\Program Files\Microsoft Visual Studio\2022\Enterprise\VC\Auxiliary\Build\vcvarsall.bat" x64
msys2 -c './build.sh' %*

@REM call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvarsall.bat" x64
@REM C:/msys64/usr/bin/bash -c './build.sh'
