#!/bin/bash

BUTTON=${button:-}

if [ "x${BUTTON}" == "x1" ]; then
    ACTION=$(xrescat i3xrocks.action.todoist "xdg-open https://todoist.com/app/#/today")
    /usr/bin/i3-msg -q exec "$ACTION"
fi

# Setup https://github.com/sachaos/todoist
# Get total task today, and print the first task in the list
todoist sync && todoist list --filter '(overdue | today)' | ruby -e 'tasks=STDIN.read.split("\n"); first=tasks.first.split; puts "#{tasks.length} tasks left. Next: ([#{first[1]}] #{first[4]} #{content=first[6..16].join(" "); content.length < 30 ? content : "#{content[0..30]}..."})"'
