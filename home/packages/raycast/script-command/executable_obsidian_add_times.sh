#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title add times
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 🗒️
# @raycast.argument1 { "type": "text", "placeholder": "Take memos" }

current_time=$(date +"%H:%M")
memo=$(echo "$1" | sed 's/ /%20/g' )
open --background "obsidian://advanced-uri?vault=obsidian&daily=true&heading=分報&mode=append&data=-%20$current_time%20$memo"