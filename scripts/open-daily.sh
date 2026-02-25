#!/bin/bash
# Open today's daily note in Obsidian
today=$(date +%Y-%m-%d)
xdg-open "obsidian://open?vault=wiki&file=daily/${today}"
