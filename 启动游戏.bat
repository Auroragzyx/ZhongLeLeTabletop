@echo off
title 众乐乐桌游 - PARTY TABLETOP
echo 正在启动《众乐乐桌游：多元桌游工坊》PC客户端...

:: 使用 Windows 内置的原生独立窗口模式启动 (无地址栏、无标签页，沉浸式游戏窗体)
start msedge --app="%~dp0index.html" --window-size=1366,768

exit
