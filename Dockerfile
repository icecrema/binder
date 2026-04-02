FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y curl ca-certificates python3 python3-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Scarica sshx ma non lo esegue durante la build
RUN curl -sSf https://sshx.io/get -o /tmp/get_sshx.sh && \
    chmod +x /tmp/get_sshx.sh

# Esegui sshx run all'avvio (non durante la build)
CMD ["sh", "-c", "/tmp/get_sshx.sh && sshx run"]
