# DevOps Lab

This repository contains the **implementation side** of a structured DevOps learning lab.

The lab follows a 90-day roadmap focused on building real DevOps engineering skills through hands-on implementation.

Current roadmap:

Docker → CI/CD → Infrastructure as Code → Kubernetes → Observability → Security → Production systems.

Current progress:

Day 26 / Phase 4 — CI/CD Hardening

---

## What this repository contains

This repository includes the working implementation of the lab:

* Docker container builds
* local CI pipeline simulation
* GitHub Actions pipeline
* container health checks
* artifact generation

Supporting documentation and engineering notes live in the companion repository:

https://github.com/carloschongdev/devops-lab-claude

---

## Running the container

Build the container:

```
docker build -t devops-lab .
```

Run the container:

```
docker run -p 8080:8080 devops-lab
```

---

## Running the local pipeline

The project includes a local pipeline script that simulates CI behavior.

Run:

```
./scripts/run-pipeline.sh
```

The script will:

* build the container
* run validation checks
* generate pipeline artifacts
* simulate a CI pipeline locally

---

## CI Pipeline

A GitHub Actions workflow runs automatically on pushes.

The pipeline performs:

* container build
* container execution
* health check validation
* artifact upload

---

## Purpose of the lab

The objective of this project is to develop practical DevOps engineering skills through iterative implementation and experimentation.
