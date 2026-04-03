FROM jupyter/base-notebook:latest

USER root
# Installiamo tmate e Java subito
RUN apt-get update && \
    apt-get install -y tmate wget openjdk-17-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan

# Script che avvia tmate e scrive il link in un file
RUN echo '#!/bin/bash\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait-for-server\n\
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}" > /home/jovyan/LINK_SSH_QUI.txt\n\
# Avvia Jupyter normalmente\n\
start-notebook.sh' > /home/jovyan/entrypoint.sh && chmod +x /home/jovyan/entrypoint.sh

CMD ["/home/jovyan/entrypoint.sh"]
