# Dockerfile del contenedor base
FROM docker:dind
RUN apk add --no-cache bash

WORKDIR /app
COPY run_benchmark.sh /app/run_benchmark.sh
RUN chmod +x /app/run_benchmark.sh

CMD ["/app/run_benchmark.sh"]

VOLUME [ "/var/run/docker.sock", "/app", "/data:/app/data" ]