FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        kiwix-tools \
    && rm -rf /var/lib/apt/lists/*

COPY start-kiwix.sh /usr/local/bin/start-kiwix.sh

RUN chmod +x /usr/local/bin/start-kiwix.sh

ENTRYPOINT ["/usr/local/bin/start-kiwix.sh"]
