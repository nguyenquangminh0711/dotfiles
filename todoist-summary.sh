#!/bin/bash

# Setup https://github.com/sachaos/todoist
# Get total task today, and print the first task in the list
todoist sync && todoist list --filter '(overdue | today)' | ruby -e 'tasks=STDIN.read.split("\n"); first=tasks.first.split; puts "#{tasks.length} tasks left. Next: ([#{first[1]}] #{first[4]} #{content=first[6..16].join(" "); content.length < 30 ? content : "#{content[0..30]}..."})"'
