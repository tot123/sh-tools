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
set /p port=������ָ���˿ڣ�
 
 
if  "%port%" == "" (
  echo.
  call :ColorText 0c "��Ч�˿�"
  echo.
  echo.
  goto cmdchoice		
)
 
 
for /f "tokens=5" %%a  in ('netstat /ano ^| findstr %port%') do ( set PidList=%%a)
 
if  "%PidList%" == "" (
  echo.
  call :ColorText 0c "���̲�����"
  echo.
  echo.
  goto cmdchoice
)
 
for /f "tokens=1" %%b in ('tasklist ^| findstr %PidList%') do ( set PName=%%b)
 
echo.
echo =========================
echo.
echo.
echo *�˿�(%port%)��PID��(%PidList%)
echo.
echo.
call :ColorText 0a "        %PName%"
echo.
echo.
echo =========================
echo.
set "select="
 
echo.
echo.�Ƿ���ֹ�ý���
echo  0: ��
echo. 1: ��
echo. 2: �鿴�˿�ʹ�ý��̺ͷ���
set/p select=��ѡ��:
 
if "%select%"=="0" (goto cmd3)
if "%select%"=="1" (goto cmd1)
if "%select%"=="2" (goto cmd2)
echo.
call :ColorText 0c "��Ч�ַ��������˳�"
echo.
echo.
goto cmd3
 
:cmdchoice
set "selectmore="
 
set/p selectmore=�Ƿ�鿴���н���(0: ��, �˳���1: ��):
 
if "%selectmore%"=="0" (goto cmd3)
if "%selectmore%"=="1" (goto cmd2)
echo.
call :ColorText 0c "��Ч�ַ��������˳�"
echo.
echo.
goto cmd3
 
:cmd1
echo ��ֹ������...
taskkill /f /pid %PidList%
echo ��������ֹ
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