# Week 4 — Local Pipeline Implementation

This week focused on implementing a local CI pipeline simulation.

The objective was to understand how CI pipelines work internally before relying on a hosted CI system.

Implementation:

A pipeline script (`run-pipeline.sh`) was created to simulate CI stages locally.

The script performs the following stages:

1. Build the Docker image
2. Run the container
3. Perform a health check
4. Generate build artifacts

Engineering practices used in the script:

- `set -Euo pipefail` for strict error handling
- `trap` for handling failures
- structured logging with levels (INFO, WARN, ERROR)
- colored terminal output
- timing of pipeline stages
- artifact generation in JSON format

Lessons learned:

Implementing a local pipeline helps understand how CI systems orchestrate build and validation processes.

This also improves debugging because issues can be reproduced locally before pushing to CI.