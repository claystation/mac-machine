#!/usr/bin/env bash
# tmux-project-picker
# Usage: tmux-project-picker <subdir> (e.g., tmux-project-picker projects)

# Check for argument
if [ -z "$1" ]; then
    echo "Usage: $0 <subdir> (relative to \$HOME)"
    exit 1
fi

# Set project directory relative to $HOME
PROJECT_DIR="$HOME/$1"

# Ensure directory exists
if [ ! -d "$PROJECT_DIR" ]; then
    echo "Directory $PROJECT_DIR does not exist"
    exit 1
fi

# Pick a project directory (portable)
SESSION=$(find "$PROJECT_DIR" -maxdepth 1 -mindepth 1 -type d \
    | sed "s|$PROJECT_DIR/||" \
    | fzf --prompt="Select project in $1: ") || exit 0

# Run tmux session creation in the parent server
tmux run-shell "tmux new-session -A -s '$SESSION' -c '$PROJECT_DIR/$SESSION'"

