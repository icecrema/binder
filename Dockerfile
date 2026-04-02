FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Installa curl (necessario per eseguire il comando)
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crea utente per Binder
RUN useradd -m -s /bin/bash jovyan

USER jovyan
WORKDIR /home/jovyan

# Esegui curl per installare ed eseguire sshx run
CMD ["sh", "-c", "curl -sSf https://sshx.io/get | sh -s run"]
