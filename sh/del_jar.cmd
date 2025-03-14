@echo off
rem 这里写你的仓库路径
set REPOSITORY_PATH=D:\server\maven\repository
rem 正在搜索...
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*lastUpdated*"') do (
    del /s /q %%i
)
rem 搜索完毕

rem 这里写你的仓库路径
set REPOSITORY_PATH=C:\Users\v_tangsu01\.m2\repository
rem 正在搜索...
for /f "delims=" %%i in ('dir /b /s "%REPOSITORY_PATH%\*lastUpdated*"') do (
    del /s /q %%i
)
rem 搜索完毕
pause
