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

