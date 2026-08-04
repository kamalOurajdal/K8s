#!/bin/bash

# Local Development Setup Script for ep-lib microservices
# This script sets up a service for local development with ep-lib

set -e

SERVICE_NAME=$1 # take the first argument as the service name
SERVICE_NAME="${SERVICE_NAME#/}" # Remove leading slash if present (/ep-api)
SERVICE_NAME="${SERVICE_NAME%/}" # Remove trailing slash if present (ep-api/)
SERVICE_DIR="$PWD/$SERVICE_NAME"

# Check if service exists
if [ ! -d "$SERVICE_DIR" ]; then
    echo "Error: Service directory '$SERVICE_NAME' not found"
    exit 1
fi

echo "Setting up local development for $SERVICE_NAME..."
echo ""

# Navigate to service
cd "$SERVICE_DIR"

# Create virtual environment
echo "Creating virtual environment..."
python3.10 -m venv venv
echo "Virtual environment created"
echo ""

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo "Virtual environment activated"
echo ""

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip --quiet
echo "Pip upgraded"
echo ""

# # Install ep-lib
# echo "Installing ep-lib..."
# pip install -e ../../ep-lib
# echo "ep-lib installed"
# echo ""


# Install service dependencies
echo "Installing service dependencies..."
pip install -r requirements.txt
echo "Dependencies installed"

echo ""
echo "========================================"
echo "Setup complete for $SERVICE_NAME!"
echo "========================================"
echo ""
echo "To activate the virtual environment:"
echo "  cd $SERVICE_NAME"
echo "  source venv/bin/activate"
echo ""
echo "To run the service:"
echo "python application.py run"
echo ""
echo "To deactivate when done:"
echo "  deactivate"
echo ""

