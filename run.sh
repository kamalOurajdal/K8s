#!/bin/bash
# -----------------------------------------------------------------------------
# Usage: ./run.sh <folder_name> [--port N]
# This script auto-detects if a service is Flask or Angular and starts it.
# -----------------------------------------------------------------------------

# Get the absolute path of the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Capture the first argument as FOLDER; if empty, print usage and stop and remove '/' in the end if it exists
FOLDER="${1:?Usage: run.sh <folder> [--port N]}"
FOLDER="${FOLDER#/}"
FOLDER="${FOLDER%/}"

VENV_DIR="venv"

# Shift the arguments so that $1 becomes the next item (handling flags like --port)
shift

# --- SET TERMINAL TITLE ---
# \033]0; sets the title, \007 ends the sequence. This labels the window/tab.
echo -ne "\033]0;${FOLDER}\007"

# Initialize an empty variable for the port argument
PORT_ARG=""

# Loop through remaining arguments to find the --port flag
while [ $# -gt 0 ]; do
  case "$1" in
    --port)
      PORT_ARG="$2" # Assign the number following --port to PORT_ARG
      shift 2        # Skip both '--port' and the number
      ;;
    *)
      shift          # Skip any other unknown arguments
      ;;
  esac
done

# Define the full path to the target service folder
DIR="$SCRIPT_DIR/$FOLDER"

# Safety check: Exit if the folder provided does not exist
if [ ! -d "$DIR" ]; then
  echo "[ERROR] Folder not found: $FOLDER"
  exit 1
fi

# -----------------------------------------------------------------------------
# FLASK (PYTHON) DETECTION LOGIC
# -----------------------------------------------------------------------------
# Check if application.py exists in the folder
if [ -f "$DIR/application.py" ]; then
  export FLASK_APP="application.py"
  
  # Look for the virtual environment activation script (Windows path)
  if [ -f "$DIR/$VENV_DIR/Scripts/activate" ]; then
    source "$DIR/$VENV_DIR/Scripts/activate"
    
  # Look for the virtual environment activation script (Linux/Mac path)
  elif [ -f "$DIR/$VENV_DIR/bin/activate" ]; then
    source "$DIR/$VENV_DIR/bin/activate"
    
  else
    # If no virtual environment is found, warn the user and exit
    echo "[ERROR] $FOLDER: venv not found. Create it with: cd $FOLDER && python -m venv $VENV_DIR"
    exit 1
  fi

  case "$FOLDER" in
    ep-api) PORT="${PORT_ARG:-5000}" ;; # API default
    ep-auth) PORT="${PORT_ARG:-5010}" ;; # Auth default
    ep-bot) PORT="${PORT_ARG:-5001}" ;; # Bot default
    *)     PORT="${PORT_ARG:-5000}" ;; # Any other Flask app default
  esac

  echo "Starting $FOLDER (Flask) on port $PORT..."
  
  # Move into the service directory
  cd "$DIR" || exit 1
  
  # Execute the python application
  echo "flask run --port $PORT"
  python -m flask run --port $PORT --debug
  exit 0
fi

# -----------------------------------------------------------------------------
# ANGULAR DETECTION LOGIC
# -----------------------------------------------------------------------------
# Check if both package.json and angular.json exist
if [ -f "$DIR/package.json" ] && [ -f "$DIR/angular.json" ]; then
  
  # Assign default ports based on the specific folder name
  case "$FOLDER" in
    ep-fo) PORT="${PORT_ARG:-4200}" ;; # Front Office default
    ep-bo) PORT="${PORT_ARG:-4201}" ;; # Back Office default
    *)     PORT="${PORT_ARG:-4200}" ;; # Any other Angular app default
  esac

  echo "Starting $FOLDER (Angular) on port $PORT..."
  
  # Move into the service directory
  cd "$DIR" || exit 1
  
  # Run the Angular dev server using npx (local project dependency)
  npx ng serve --port "$PORT"
  exit 0
fi