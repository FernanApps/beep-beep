#!/bin/bash

# Find all Dockerfiles in the project and build images for each one
find . -type f -name "Dockerfile" | while read dockerfile; do
    dir=$(dirname "$dockerfile")  # Get the directory where the Dockerfile is located
    imagen=$(basename "$dir")     # Use the directory name as the image name
    echo "📦 Building image: $imagen"
    docker build -t "$imagen" "$dir"  # Build the Docker image using the directory as the context
done
