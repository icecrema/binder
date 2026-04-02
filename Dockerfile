FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl ca-certificates python3 python3-minimal && \
    curl -sSf https://sshx.io/get | sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Esegui sshx direttamente (già installato)
CMD ["sshx", "run"]
