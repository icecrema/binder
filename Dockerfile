FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installa solo lo stretto necessario
RUN apt-get update && apt-get install -y \
    curl \
    ca-certificates \
    && curl -sSf https://sshx.io/get | sh \
    && apt-get remove -y curl ca-certificates \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

CMD ["sshx"]
