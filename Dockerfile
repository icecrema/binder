FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y tmate python3 python3-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Script che avvia tmate, cattura il link e lo serve via HTTP
RUN echo '#!/bin/bash\n\
set -e\n\
echo "Starting tmate..." > /tmp/status.html\n\
# Avvia tmate in background e salva l\'output\n\
tmate -F 2>&1 | tee /tmp/tmate.log &\n\
# Aspetta il link (max 30 secondi)\n\
for i in {1..30}; do\n\
    if grep -q "ssh session:" /tmp/tmate.log 2>/dev/null; then\n\
        LINK=$(grep "ssh session:" /tmp/tmate.log | head -1)\n\
        echo "<html><body><h1>✅ tmate pronto</h1><pre style=\"font-size:16px\">$LINK</pre><p>Condividi questo link per accedere al terminale.</p></body></html>" > /tmp/index.html\n\
        break\n\
    fi\n\
    echo "<html><body><h1>⏳ Attendi... avvio tmate</h1><p>Il link apparirà tra pochi secondi. Ricarica la pagina.</p></body></html>" > /tmp/index.html\n\
    sleep 1\n\
done\n\
# Avvia server HTTP sulla porta 8888 (richiesta da Binder)\n\
cd /tmp\n\
python3 -m http.server 8888' > /usr/local/bin/start.sh && chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
