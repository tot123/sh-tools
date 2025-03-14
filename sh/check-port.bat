@echo off
setlocal enabledelayedexpansion

:: 参数处理
set "port=%~1"
if "%port%"=="" set port=8080

:: 验证端口格式
echo %port% | findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 (
    echo 错误：端口必须是数字
    exit /b 1
)

:: 检查端口占用
set pid=
for /f "tokens=5" %%a in ('netstat -ano ^| findstr ":%port% "') do (
    set pid=%%a
    goto kill_process
)

:: 未找到占用情况
echo 端口 %port% 未被占用
exit /b 0

:kill_process
echo 发现占用进程 PID: %pid%

:: 获取进程信息
for /f "tokens=1,2 delims=," %%b in (
    'wmic process where "ProcessId=%pid%" get Name,ExecutablePath /format:csv ^| findstr /v "Node"'
) do (
    set "process_name=%%b"
    set "exe_path=%%c"
)

:: 用户确认
set /p confirm="确认终止进程 [!process_name!] (Y/N)? "
if /i "!confirm!" neq "Y" (
    echo 操作已取消
    exit /b 0
)

:: 终止进程
taskkill /F /PID %pid% >nul 2>&1
if %errorlevel% equ 0 (
    echo 成功终止进程 %pid%
) else (
    echo 终止进程失败，可能需要管理员权限
)