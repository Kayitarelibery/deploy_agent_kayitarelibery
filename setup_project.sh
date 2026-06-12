#!/bin/bash

# ----------------------------
# Global variables
# ----------------------------
PROJECT_DIR=""
ARCHIVE_NAME=""

# ----------------------------
# Cleanup on Ctrl+C
# ----------------------------
cleanup() {
    echo ""
    echo "CTRL+C detected. Cleaning up..."

    if [ -n "$PROJECT_DIR" ] && [ -d "$PROJECT_DIR" ]; then
        ARCHIVE_NAME="${PROJECT_DIR}_archive.tar.gz"

        tar -czf "$ARCHIVE_NAME" "$PROJECT_DIR" 2>/dev/null
        rm -rf "$PROJECT_DIR"

        echo "Archive created: $ARCHIVE_NAME"
        echo "Project directory removed."
    else
        echo "No project to archive yet."
    fi

    exit 1
}

trap cleanup SIGINT

read -p "Enter project name suffix: " project_name
PROJECT_DIR="attendance_tracker_${project_name}"


mkdir -p "$PROJECT_DIR/Helpers"
mkdir -p "$PROJECT_DIR/reports"

touch "$PROJECT_DIR/attendance_checker.py"
touch "$PROJECT_DIR/reports/reports.log"

# ----------------------------
# Check required source files
# ----------------------------
if [ ! -f "assets.csv" ] || [ ! -f "config.json" ]; then
    echo "ERROR: Missing assets.csv or config.json in current directory"
    exit 1
fi

cp assets.csv "$PROJECT_DIR/Helpers/"
cp config.json "$PROJECT_DIR/Helpers/"

# ----------------------------
# Config update
# ----------------------------
read -p "Do you want to change attendance thresholds? (yes/no): " answer

if [ "$answer" = "yes" ]; then

    read -p "Enter Warning Threshold (default 75): " warning
    read -p "Enter Failure Threshold (default 50): " failure

    # Validate warning
    while ! [[ "$warning" =~ ^[0-9]+$ ]]; do
        echo "Numbers only."
        read -p "Enter Warning Threshold: " warning
    done

    # Validate failure
    while ! [[ "$failure" =~ ^[0-9]+$ ]]; do
        echo "Numbers only."
        read -p "Enter Failure Threshold: " failure
    done

    # Safe sed replacement (handles spacing)
    sed -i "s/\"warning_threshold\"[ ]*:[ ]*[0-9]\+/\"warning_threshold\": $warning/" \
        "$PROJECT_DIR/Helpers/config.json"

    sed -i "s/\"failure_threshold\"[ ]*:[ ]*[0-9]\+/\"failure_threshold\": $failure/" \
        "$PROJECT_DIR/Helpers/config.json"
fi

# ----------------------------
# Health check
# ----------------------------
echo ""
echo "Running health check..."

if python3 --version >/dev/null 2>&1; then
    echo "Python3 found."
else
    echo "WARNING: Python3 not installed."
fi

# ----------------------------
# Structure verification
# ----------------------------
if [ -f "$PROJECT_DIR/attendance_checker.py" ] &&
   [ -f "$PROJECT_DIR/Helpers/assets.csv" ] &&
   [ -f "$PROJECT_DIR/Helpers/config.json" ] &&
   [ -f "$PROJECT_DIR/reports/reports.log" ]; then

    echo "Directory structure verified."
else
    echo "Directory structure verification failed."
fi

echo ""
echo "Project setup completed successfully."
