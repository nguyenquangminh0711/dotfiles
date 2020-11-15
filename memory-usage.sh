#!/bin/bash

echo "√$(free -g -h  | awk '{if (NR==2) print $3}')"
