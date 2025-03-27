@echo off
setlocal enabledelayedexpansion

:: 设置默认Maven仓库路径
set "maven_repo=%USERPROFILE%\.m2\repository"

:: 检查目录是否存在
if not exist "%maven_repo%" (
    echo 错误：Maven仓库目录不存在 - %maven_repo%
    pause
    exit /b 1
)

:: 查找所有.lastUpdated文件
echo 正在扫描.lastUpdated文件...
set "file_count=0"
for /r "%maven_repo%" %%f in (*.lastUpdated) do (
    set /a file_count+=1
    set "last_updated_file=%%f"
)

:: 如果没有找到文件，直接退出
if %file_count% equ 0 (
    echo 未找到.lastUpdated文件，无需清理。
    pause
    exit /b 0
)

:: 显示找到的文件数量
echo 找到 %file_count% 个.lastUpdated文件。

:: 提取需要清理的目录
echo 正在提取需要清理的目录...
set "dir_list="
for /r "%maven_repo%" %%f in (*.lastUpdated) do (
    set "dir_path=%%~dpf"
    set "dir_list=!dir_list! "%%~dpf""
)

:: 去重目录列表
echo 正在去重目录列表...
set "unique_dirs="
for %%d in (!dir_list!) do (
    if not defined unique_dirs (
        set "unique_dirs=%%d"
    ) else (
        echo !unique_dirs! | find "%%d" >nul
        if errorlevel 1 set "unique_dirs=!unique_dirs! %%d"
    )
)

:: 显示将要清理的目录
echo 以下目录将被清理：
for %%d in (!unique_dirs!) do (
    echo   %%d
)

:: 用户确认
set /p confirm="确认清理以上目录？(Y/N) "
if /i "%confirm%" neq "Y" (
    echo 操作已取消。
    pause
    exit /b 0
)

:: 执行清理操作
echo 正在清理...
for %%d in (!unique_dirs!) do (
    rd /s /q "%%d" 2>nul
    if errorlevel 1 (
        echo 清理失败：%%d
    ) else (
        echo 已清理：%%d
    )
)

:: 完成提示
echo 清理操作完成。
pause