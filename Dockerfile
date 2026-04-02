FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl ca-certificates python3 python3-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["sh", "-c", "curl -sSf https://sshx.io/get | sh -s run"]
