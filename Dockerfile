FROM jupyter/base-notebook:latest

USER root
# Installiamo tmate e Java per Minecraft subito
RUN apt-get update && \
    apt-get install -y tmate wget openjdk-17-jre-headless && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan
WORKDIR /home/jovyan

# Questo script farà partire tmate in background
RUN echo '#!/bin/bash\n\
tmate -S /tmp/tmate.sock new-session -d\n\
tmate -S /tmp/tmate.sock wait-for-server\n\
tmate -S /tmp/tmate.sock display -p "#{tmate_ssh}" > /home/jovyan/link_ssh.txt\n\
jupyter notebook' > /home/jovyan/start_all.sh && chmod +x /home/jovyan/start_all.sh

# Facciamo credere a Binder che stiamo solo lanciando Jupyter
CMD ["/home/jovyan/start_all.sh"]
