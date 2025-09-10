#!/bin/bash

set -e

# 檢查參數
if [ $# -ne 1 ]; then
    echo "使用方式: $0 [refresh|backup]"
    exit 1
fi

ACTION="$1"

# 檢查參數是否有效
if [ "$ACTION" != "refresh" ] && [ "$ACTION" != "backup" ]; then
    echo "錯誤: 參數必須是 'refresh' 或 'backup'"
    exit 1
fi

# 清理函數
cleanup() {
    if [ -d "/tmp/vim" ]; then
        echo "清理 /tmp/vim 目錄..."
        rm -rf /tmp/vim
    fi
}

# 設定清理陷阱
trap cleanup EXIT

echo "開始執行 $ACTION 操作..."

# 1. 從 GitHub 下載至 /tmp/vim
echo "從 github.com/pardnchiu/vim 下載至 /tmp/vim"
if [ -d "/tmp/vim" ]; then
    rm -rf /tmp/vim
fi

git clone https://github.com/pardnchiu/vim.git /tmp/vim

# 2. 進入 /tmp/vim/
echo "進入 /tmp/vim/ 目錄"
cd /tmp/vim/

# 3. 執行對應的腳本
if [ "$ACTION" = "refresh" ]; then
    echo "執行 restore 腳本"
    if [ -f "/tmp/vim/restore" ]; then
        bash /tmp/vim/restore
    else
        echo "錯誤: restore 腳本不存在"
        exit 1
    fi
elif [ "$ACTION" = "backup" ]; then
    echo "執行 backup 腳本"
    if [ -f "/tmp/vim/backup" ]; then
        bash /tmp/vim/backup
    else
        echo "錯誤: backup 腳本不存在"
        exit 1
    fi
fi

echo "$ACTION 操作完成"

# 4. 刪除會由 cleanup 函數處理
