#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./setup-local-dev.sh <users|products|orders> [--recreate]

Creates a local .venv for one service and installs its development dependencies.
EOF
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

case "$1" in
  -h|--help)
    usage
    exit 0
    ;;
esac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_NAME="${1#/}"
SERVICE_NAME="${SERVICE_NAME%/}"
shift

RECREATE=0

while [ $# -gt 0 ]; do
  case "$1" in
    --recreate)
      RECREATE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      usage
      exit 1
      ;;
  esac
done

case "$SERVICE_NAME" in
  users|products|orders) ;;
  *)
    echo "[ERROR] Unknown service: $SERVICE_NAME"
    usage
    exit 1
    ;;
esac

SERVICE_DIR="$SCRIPT_DIR/$SERVICE_NAME"
VENV_DIR="$SERVICE_DIR/.venv"
REQUIREMENTS_FILE="$SERVICE_DIR/requirements-dev.txt"

if [ ! -f "$SERVICE_DIR/run.py" ]; then
  echo "[ERROR] Expected Flask entrypoint not found: $SERVICE_NAME/run.py"
  exit 1
fi

if [ ! -f "$REQUIREMENTS_FILE" ]; then
  REQUIREMENTS_FILE="$SERVICE_DIR/requirements.txt"
fi

if [ "$RECREATE" -eq 1 ] && [ -d "$VENV_DIR" ]; then
  echo "Removing existing virtual environment for $SERVICE_NAME..."
  rm -rf "$VENV_DIR"
fi

echo "Setting up local development for $SERVICE_NAME..."
echo ""

if [ ! -x "$VENV_DIR/bin/python" ]; then
  echo "Creating virtual environment at ${VENV_DIR#$SCRIPT_DIR/}..."
  python3 -m venv "$VENV_DIR"
else
  echo "Using existing virtual environment at ${VENV_DIR#$SCRIPT_DIR/}..."
fi

source "$VENV_DIR/bin/activate"

echo "Upgrading pip..."
python -m pip install --upgrade pip --quiet

echo "Installing dependencies from ${REQUIREMENTS_FILE#$SCRIPT_DIR/}..."
python -m pip install -r "$REQUIREMENTS_FILE"

echo ""
echo "========================================"
echo "Setup complete for $SERVICE_NAME!"
echo "========================================"
echo ""
echo "To activate the virtual environment:"
echo "  source $SERVICE_NAME/.venv/bin/activate"
echo ""
echo "To run the service:"
echo "  ./run.sh $SERVICE_NAME"
echo ""
echo "To recreate this environment:"
echo "  ./setup-local-dev.sh $SERVICE_NAME --recreate"
echo ""

