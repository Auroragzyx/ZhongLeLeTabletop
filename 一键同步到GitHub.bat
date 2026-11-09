@echo off
chcp 65001 >nul
title 众乐乐桌游 - GitHub 个人私有仓库备份同步器

echo ==============================================================
echo        《众乐乐桌游》 GitHub 个人私有仓库自动同步器
echo ==============================================================
echo.
echo 本工具将帮助你把本地的游戏代码、美术切图与架构一键备份至 GitHub 私有仓库！
echo.

:: 检查是否已配置 remote origin
git remote get-url origin >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo [首次设置] 当前尚未绑定 GitHub 远程仓库！
    echo 请按以下两步操作：
    echo 1. 打开浏览器登录 GitHub，点击右上角 '+' -> 'New repository'
    echo 2. Repository name 填入: ZhongLeLeTabletop ，并务必勾选 'Private' (私有)
    echo 3. 复制生成的仓库地址 (例如: https://github.com/你的名字/ZhongLeLeTabletop.git)
    echo.
    set /p REPO_URL="请输入你的 GitHub 仓库地址: "
    if not defined REPO_URL (
        echo 输入为空，操作取消。
        pause
        exit /b
    )
    git remote add origin %REPO_URL%
    git branch -M main
    echo 已成功绑定远程仓库: %REPO_URL%
)

echo.
echo 正在检查本地更新并提交...
git add .
git commit -m "backup: auto-sync local game progress" >nul 2>&1

echo 正在推送至 GitHub 个人私有仓库 (main)...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [成功] 全部游戏代码与美术资产已安全备份至你的 GitHub 私有仓库！
) else (
    echo.
    echo [提示] 推送遇到权限验证或网络中断。
    echo 如果提示需要密码，请使用你的 GitHub Personal Access Token (PAT) 替代密码登录。
)

echo.
pause
