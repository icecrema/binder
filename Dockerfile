# Usa un tag specifico (obbligatorio su Binder)
FROM debian:bookworm-slim

# Installazione dipendenze e creazione utente Binder (UID 1000)
RUN apt-get update && \
    apt-get install -y tmate python3 python3-minimal procps && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd -m -u 1000 jovyan

USER jovyan
ENV HOME=/home/jovyan
WORKDIR $HOME

# Script ottimizzato
RUN echo '#!/bin/bash\n\
set -e\n\
# Avvia tmate in background forzando il caricamento\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait-for-server\n\
\n\
# Estrae il link SSH\n\
for i in {1..60}; do\n\
    LINK=$(tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}")\n\
    if [[ $LINK == *"ssh"* ]]; then\n\
        echo "<html><body style=\"font-family:sans-serif; text-align:center; padding-top:50px;\">\n\
              <h1>✅ Sessione tmate Attiva</h1>\n\
              <div style=\"background:#eee; display:inline-block; padding:20px; border-radius:10px;\">\n\
              <code style=\"font-size:18px;\">$LINK</code>\n\
              </div>\n\
              <p>Copia il comando sopra nel tuo terminale locale.</p>\n\
              </body></html>" > $HOME/index.html\n\
        break\n\
    fi\n\
    echo "<html><body><h1>⏳ Generazione link in corso ($i/60)...</h1><script>setTimeout(() => location.reload(), 2000)</script></body></html>" > $HOME/index.html\n\
    sleep 2\n\
done\n\
\n\
# Avvia il server sulla porta 8888 (quella che Binder espone di default)\n\
python3 -m http.server 8888' > $HOME/start.sh && chmod +x $HOME/start.sh

# Binder richiede che la porta sia esposta
EXPOSE 8888

CMD ["/home/jovyan/start.sh"]
