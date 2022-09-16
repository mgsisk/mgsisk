#!/bin/zsh

[ -d /opt/homebrew ] && eval "$(/opt/homebrew/bin/brew shellenv)"
[ -d /home/linuxbrew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

path=(/usr/local/sbin $path ./node_modules/.bin ./vendor/bin)
