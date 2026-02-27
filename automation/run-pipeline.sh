#!/bin/bash

# Simulación de ejecución de pipeline
# Este script representa lo que un sistema CI ejecutará automáticamente.
# Aún se ejecuta manualmente en esta fase del laboratorio.

echo "Running manual CI pipeline simulation"

echo "Project: devops-lab"
date

echo "=== PIPELINE START ==="

echo "Step 1 - Validate repository state"
git status

echo "Step 2 - Confirm project location"
pwd

echo "Step 3 - Inspect project structure"
ls - R

echo "Pipeline simulation complete successfully"

set -e

echo "==Pre-run validation phase =="

if [ ! -f "Licence"]; then
    echo "ERROR: Licence not found. Run script from project root."
    exit 1
fi

if [ ! -d "automation" ]; then
    echo "ERROR: automation directory missing."
    exit 1
fi

if ! command -v git >/dev/null 2/&1; then 
    echo "ERROR: git is not available in PATH."
    exit 1
fi

echo "Environment validation passed."
echo "Starting pipeline..."

