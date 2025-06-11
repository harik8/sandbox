FROM ubuntu:20.04

# Set environment variables
ENV RUNNER_VERSION=2.325.0
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
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L \
    https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    echo "5020da7139d85c776059f351e0de8fdec753affc9c558e892472d43ebeb518f4  actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz" | shasum -a 256 -c && \
    tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz && \
    rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER runner

ENTRYPOINT ["/entrypoint.sh"]