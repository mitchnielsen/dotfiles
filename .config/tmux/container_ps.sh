#!/usr/bin/env bash

# Prints out the number of running
# containers. To be displayed in the
# tmux status bar.

count=$(docker ps -q | wc -l)

case $count in
  0) exit 0 ;;
  1) echo "| $count container" ;;
  *) echo "| $count containers" ;;
esac
