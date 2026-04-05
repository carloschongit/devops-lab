# Week 5 — GitHub Actions Pipeline

This week focused on implementing the CI pipeline in GitHub Actions.

Goals:

- Automate the build process on every commit
- Validate container execution
- ensure the pipeline produces reproducible results

Pipeline features implemented:

- container build using Docker
- container execution for validation
- health check using `curl`
- artifact generation
- artifact upload in GitHub Actions

Important workflow practices:

- usage of official actions v4
- commit SHA tagging for traceability
- cleanup steps using `if: always()`
- structured pipeline stages

Lessons learned:

GitHub Actions allows defining CI pipelines using YAML workflows.

The workflow automatically runs when code is pushed to the repository, ensuring that every change is validated.

This provides fast feedback on integration issues.