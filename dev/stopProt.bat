@Echo Off
:: created by tarzan LIU
 
SETLOCAL EnableDelayedExpansion
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set "DEL=%%a"
)
call :ColorText 09 "POWER BY CITRUS"
echo.
goto cmdmain
 
:cmdmain
set /p port=请输入指定端口：
 
 
if  "%port%" == "" (
  echo.
  call :ColorText 0c "无效端口"
  echo.
  echo.
  goto cmdchoice		
)
 
 
for /f "tokens=5" %%a  in ('netstat /ano ^| findstr %port%') do ( set PidList=%%a)
 
if  "%PidList%" == "" (
  echo.
  call :ColorText 0c "进程不存在"
  echo.
  echo.
  goto cmdchoice
)
 
for /f "tokens=1" %%b in ('tasklist ^| findstr %PidList%') do ( set PName=%%b)
 
echo.
echo =========================
echo.
echo.
echo *端口(%port%)的PID是(%PidList%)
echo.
echo.
call :ColorText 0a "        %PName%"
echo.
echo.
echo =========================
echo.
set "select="
 
echo.
echo.是否终止该进程
echo  0: 否
echo. 1: 是
echo. 2: 查看端口使用进程和服务
set/p select=请选择:
 
if "%select%"=="0" (goto cmd3)
if "%select%"=="1" (goto cmd1)
if "%select%"=="2" (goto cmd2)
echo.
call :ColorText 0c "无效字符，即将退出"
echo.
echo.
goto cmd3
 
:cmdchoice
set "selectmore="
 
set/p selectmore=是否查看所有进程(0: 否, 退出，1: 是):
 
if "%selectmore%"=="0" (goto cmd3)
if "%selectmore%"=="1" (goto cmd2)
echo.
call :ColorText 0c "无效字符，即将退出"
echo.
echo.
goto cmd3
 
:cmd1
echo 终止进程中...
taskkill /f /pid %PidList%
echo 进程已终止
PAUSE >null
 
:cmd2
netstat -ano |findstr %port%
tasklist |findstr %PidList%
goto cmdmain
 
:cmd3
pause
exit
 
:ColorText
echo off
<nul set /p ".=%DEL%" > "%~2"
findstr /v /a:%1 /R "^$" "%~2" nul
del "%~2" > nul 2>&1
goto :eof