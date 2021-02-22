#!/bin/bash

spring rspec $(git diff --name-only HEAD $(git merge-base HEAD master) | grep spec) $(git diff --name-only | grep spec)
