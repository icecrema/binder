FROM jupyter/base-notebook:latest

USER root

# Installa curl
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER jovyan

# Avvia sshx in background e mantieni Jupyter attivo
CMD ["sh", "-c", "curl -sSf https://sshx.io/get | sh -s run & jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]
