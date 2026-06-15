Automated Project Bootstrapping & Process Management
## Repository

Repository Name: deploy_agent_kayitarelibery
## Project Overview

This project is an automated setup for a Student Attendance Tracker environment with a Shell script. The aim is to demonstrate Infrastructure as Code (IaC) principles by building the project structure, modifying configuration values, verifying the environment and dealing with user interruptions with signal trapping.

## Features

### 1. Directory Creation
The script will make a project folder with the following structure:
attendance_tracker_<project_name>
It also creates the following structure:

attendance_tracker_<project_name>/
├── attendance_checker.py
├── Helpers/
│   ├── assets.csv
│   └── config.json
└── reports/
└── reports.log

### 2. Dynamic Configuration
The script asks the user if they want to change the attendance thresholds.
If the user responds "yes":

Request a change of warning threshold.
Failure threshold requested is new.
Input from user is checked for numbers.
* sed is used to update the values in config.json.

### 3. Signal Handling
The script has a SIGINT trap.
On pressing CTRL+C:

Interrupt signal is handled by the script.
The entire working directory is backed up.
The incomplete project directory is deleted.
The script exits properly.

### 4. Environment Validation
Script executes a health check prior to completion.
It verifies:

Install python3 -- python3 --version
* The directory structure was found
* Required files are present

## How to Run
Make the script executable:
chmod +x setup_project.sh

Run the script:
./setup_project.sh

## Testing
The following tests were carried out:

1. Normal execution
   Successfully generated structure for a project.

2. Configuration update
   Threshold value is updated correctly, with sed.

3. Environment validation
   Installed python successfully.

4. Signal handling
   CTRL+C creates and cleans archive.

## Archive Feature

To check the archive feature:

1. Run the script.
When running, press CTRL+C.
3. An archive is created.
4. The partial project directory is deleted.

## Author

Libery Kayitare
## Video Demonstration

Video Link:
https://youtu.be/_Eby-0hiD-Y
