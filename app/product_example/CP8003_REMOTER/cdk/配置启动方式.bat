@echo off
setlocal EnableExtensions EnableDelayedExpansion
chcp 936 >nul 2>&1
color 07

if exist "BOOT_OTP" del /f /q "BOOT_OTP" >nul 2>&1

echo =============================
echo   请选择启动方式配置
echo =============================
echo.
echo   1. FLASH启动方式
echo   2. OTP启动方式
echo.
set /p choice=请输入您的选择 (1 或 2)，按回车: 

if "%choice%"=="1" goto :flashMode
if "%choice%"=="2" goto :otpMode

echo.
echo 无效选项，请重新运行脚本。
pause
exit /b 1

:flashMode
set "lib2g4Old=otp/lib2g4_base.a"
set "lib2g4New=flash/lib2g4_base.a"
set "ldFileOld=cp800x_2g4_otp.ld"
set "ldFileNew=e902_2g4_sleep.ld"
set "bootOtpOld=BOOT_OTP=1;"
set "bootOtpNew=BOOT_OTP=0;"
set "bootMode=FLASH"
goto :applyConfig

:otpMode
set "lib2g4Old=flash/lib2g4_base.a"
set "lib2g4New=otp/lib2g4_base.a"
set "ldFileOld=e902_2g4_sleep.ld"
set "ldFileNew=cp800x_2g4_otp.ld"
set "bootOtpOld=BOOT_OTP=0;"
set "bootOtpNew=BOOT_OTP=1;"
set "bootMode=OTP"
goto :applyConfig

:applyConfig
cls

call :replace_in_cdkproj "%lib2g4Old%" "%lib2g4New%" updated1
call :replace_in_cdkproj "%ldFileOld%" "%ldFileNew%" updated2
call :replace_in_cdkproj "%bootOtpOld%" "%bootOtpNew%" updated3

color 0A
echo =============================
echo 切换%bootMode%启动方式成功！
echo =============================
echo 已修改 .cdkproj 文件。库文件路径=%updated1%，链接脚本=%updated2%，BOOT_OTP=%updated3%
echo 请按任意键退出...
pause >nul
exit /b 0

:replace_in_cdkproj
set "oldText=%~1"
set "newText=%~2"
set "count=0"

for /r %%f in (*.cdkproj) do (
    findstr /C:"%oldText%" "%%f" >nul 2>&1
    if !errorlevel! equ 0 (
        set "tmpFile=%%f.tmp"
        powershell -NoProfile -Command "$c = Get-Content -LiteralPath '%%f' -Raw -Encoding UTF8; $c = $c.Replace('%~1','%~2'); [System.IO.File]::WriteAllText('!tmpFile!', $c, [System.Text.UTF8Encoding]::new($false))" >nul 2>&1
        if exist "!tmpFile!" (
            move /y "!tmpFile!" "%%f" >nul 2>&1
            set /a count+=1
        )
    )
)

set "%~3=!count!"
exit /b 0