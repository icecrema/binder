FROM debian:bookworm-slim

# Installazione dipendenze
RUN apt-get update && \
    apt-get install -y tmate python3 procps wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Crea l'utente richiesto da Binder
RUN useradd -m -u 1000 jovyan
USER jovyan
WORKDIR /home/jovyan

# Crea lo script di avvio
RUN echo '#!/bin/bash\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait-for-server\n\
# Genera il link SSH in un file\n\
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}" > /home/jovyan/link.txt\n\
# Avvia un server web super semplice sulla porta 8888\n\
echo "<html><body><h1>Copia questo comando:</h1><pre>$(cat /home/jovyan/link.txt)</pre></body></html>" > /home/jovyan/index.html\n\
python3 -m http.server 8888' > /home/jovyan/start.sh && chmod +x /home/jovyan/start.sh

# Comando di avvio che Binder DEVE vedere
CMD ["/home/jovyan/start.sh"]
