# Dockerfile del contenedor base
FROM docker:dind
RUN apk add --no-cache git bash

WORKDIR /app
COPY run_benchmark.sh /app/run_benchmark.sh
RUN chmod +x /app/run_benchmark.sh

CMD ["/app/run_benchmark.sh"]
