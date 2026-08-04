#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: ./run.sh <users|products|orders> [--port N] [--no-install]

Runs one Flask microservice locally.

Default ports:
  users     5001
  products  5002
  orders    5003
EOF
}

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE="${1#/}"
SERVICE="${SERVICE%/}"
shift

PORT_ARG=""
INSTALL_DEPS=1

while [ $# -gt 0 ]; do
  case "$1" in
    --port)
      if [ $# -lt 2 ] || [[ "$2" == --* ]]; then
        echo "[ERROR] --port requires a value"
        exit 1
      fi
      PORT_ARG="$2"
      shift 2
      ;;
    --no-install)
      INSTALL_DEPS=0
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

case "$SERVICE" in
  users) DEFAULT_PORT=5001 ;;
  products) DEFAULT_PORT=5002 ;;
  orders) DEFAULT_PORT=5003 ;;
  *)
    echo "[ERROR] Unknown service: $SERVICE"
    usage
    exit 1
    ;;
esac

SERVICE_DIR="$SCRIPT_DIR/$SERVICE"
VENV_DIR="$SERVICE_DIR/venv"
PORT="${PORT_ARG:-$DEFAULT_PORT}"

if [ ! -f "$SERVICE_DIR/run.py" ]; then
  echo "[ERROR] Expected Flask entrypoint not found: $SERVICE/run.py"
  exit 1
fi

echo -ne "\033]0;${SERVICE}\007"

if [ ! -x "$VENV_DIR/bin/python" ]; then
  echo "Creating virtual environment for $SERVICE..."
  python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

if [ "$INSTALL_DEPS" -eq 1 ]; then
  REQUIREMENTS_FILE="$SERVICE_DIR/requirements-dev.txt"
  if [ ! -f "$REQUIREMENTS_FILE" ]; then
    REQUIREMENTS_FILE="$SERVICE_DIR/requirements.txt"
  fi

  echo "Installing dependencies from ${REQUIREMENTS_FILE#$SCRIPT_DIR/}..."
  python -m pip install -r "$REQUIREMENTS_FILE"
fi

export FLASK_APP=run:app
export FLASK_ENV=development

if [ "$SERVICE" = "orders" ]; then
  export USERS_SERVICE_URL="${USERS_SERVICE_URL:-http://localhost:5001}"
  export PRODUCTS_SERVICE_URL="${PRODUCTS_SERVICE_URL:-http://localhost:5002}"
fi

cd "$SERVICE_DIR"
echo "Starting $SERVICE on http://localhost:$PORT"
python -m flask run --host 0.0.0.0 --port "$PORT" --debug