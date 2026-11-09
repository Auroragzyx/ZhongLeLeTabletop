@echo off
title 众乐乐桌游 - PARTY TABLETOP
echo ========================================================
echo   正在启动《众乐乐桌游：多元桌游工坊》PC客户端...
echo ========================================================

:: 优先检测并使用 Microsoft Edge 原生独立窗体模式 (无地址栏、无标签页，沉浸式桌面客户端)
if exist "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" (
    start "" "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --app="%~dp0index.html" --window-size=1366,820
    exit /b
)

if exist "C:\Program Files\Google\Chrome\Application\chrome.exe" (
    start "" "C:\Program Files\Google\Chrome\Application\chrome.exe" --app="%~dp0index.html" --window-size=1366,820
    exit /b
)

if exist "C:\Program Files\Microsoft\Edge\Application\msedge.exe" (
    start "" "C:\Program Files\Microsoft\Edge\Application\msedge.exe" --app="%~dp0index.html" --window-size=1366,820
    exit /b
)

:: 备用：调用系统默认浏览器打开
start "" "%~dp0index.html"
exit /b
