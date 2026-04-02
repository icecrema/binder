FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y tmate python3 python3-minimal && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

CMD ["tmate", "-F"]
