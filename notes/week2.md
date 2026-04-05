# Week 2 — Docker Fundamentals

This week focused on understanding how containerization works and how Docker is used in modern DevOps environments.

Key concepts studied:

- What containers are and how they differ from virtual machines
- The role of Docker in application packaging
- Docker images and containers
- The Dockerfile and how it defines a container build process
- The importance of deterministic builds

Practical work:

- Created the first Dockerfile for the project
- Built the container image locally using `docker build`
- Executed the container using `docker run`
- Verified that the application runs correctly inside the container

Lessons learned:

Containerization solves the "works on my machine" problem by packaging the application and its dependencies into a reproducible image.

Docker images act as immutable artifacts that can be promoted across environments (development, testing, production).