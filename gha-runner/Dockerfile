FROM ubuntu:20.04

# Set environment variables
ENV RUNNER_VERSION=2.329.0
ENV RUNNER_ARCH=arm64
ENV RUNNER_HASH=56768348b3d643a6a29d4ad71e9bdae0dc0ef1eb01afe0f7a8ee097b039bfaaf
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        jq \
        git \
        iproute2 \
        tar \
        bash \
        libicu66 \
        libkrb5-3 \
        zlib1g \
        sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create runner user
RUN useradd -m runner && mkdir -p /actions-runner && chown runner:runner /actions-runner
WORKDIR /actions-runner

# Download and extract runner
RUN curl -o actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    echo "${RUNNER_HASH} actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner

ENTRYPOINT ["/entrypoint.sh"]