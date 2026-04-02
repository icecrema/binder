FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y tmate python3 python3-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Script che avvia tmate, cattura l'output e lo stampa chiaramente
RUN echo '#!/bin/bash\n\
set -e\n\
echo "=== Avvio tmate... ===\n"\n\
# Forza output non bufferizzato\n\
export PYTHONUNBUFFERED=1\n\
# Esegui tmate e stampa ogni riga\n\
tmate -F 2>&1 | while IFS= read -r line; do\n\
    echo "$line"\n\
    if echo "$line" | grep -qi "ssh session"; then\n\
        echo "🔗 LINK CONDIVISIBILE: $line"\n\
    fi\n\
done' > /usr/local/bin/run-tmate && chmod +x /usr/local/bin/run-tmate

CMD ["/usr/local/bin/run-tmate"]
