@echo on
cd smoke
if errorlevel 1 exit /b 1
set "CARGO_NET_OFFLINE=true"
cargo cbuild --release
if errorlevel 1 exit /b 1
cargo ctest --release
if errorlevel 1 exit /b 1
cargo cinstall --release --prefix "%CD%\stage" --libdir "%CD%\stage\lib" --includedir "%CD%\stage\include" --bindir "%CD%\stage\bin"
if errorlevel 1 exit /b 1
cl /nologo consumer.c /Istage\include stage\lib\cargo_c_smoke.dll.lib /Fe:consumer.exe
if errorlevel 1 exit /b 1
set "PATH=%CD%\stage\bin;%PATH%"
consumer.exe
if errorlevel 1 exit /b 1
set "PKG_CONFIG_PATH=%CD%\stage\lib\pkgconfig"
pkg-config --validate cargo_c_smoke
if errorlevel 1 exit /b 1
pkg-config --modversion cargo_c_smoke | findstr /x "0.1.0"
if errorlevel 1 exit /b 1
set "EXPECTED_MACHINE=8664 machine (x64)"
if "%target_platform%" == "win-arm64" set "EXPECTED_MACHINE=AA64 machine (ARM64)"
for %%F in ("%LIBRARY_BIN%\cargo-cbuild.exe" "%LIBRARY_BIN%\cargo-ctest.exe" "%LIBRARY_BIN%\cargo-cinstall.exe" "%LIBRARY_BIN%\cargo-capi.exe" "stage\bin\cargo_c_smoke.dll" "consumer.exe") do (
    dumpbin /headers "%%~F" | findstr /c:"%EXPECTED_MACHINE%"
    if errorlevel 1 exit /b 1
)
