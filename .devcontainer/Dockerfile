FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      ca-certificates curl git zstd build-essential pkg-config \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="/home/vscode/.elan/bin:${PATH}"
