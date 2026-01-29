#!/usr/bin/env bash

# Prints out the number of running
# containers. To be displayed in the
# tmux status bar.

count=$(docker ps -q | wc -l)

case $count in 1) echo "| $count container" ;;
  2) echo "| $count containers" ;;
  *) exit 0 ;;
esac
