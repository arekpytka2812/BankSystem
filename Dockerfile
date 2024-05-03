FROM postgres:15.4

RUN apt-get update && apt-get install -y \
    postgresql-server-dev-all \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Clone pg_cron from GitHub
RUN git clone https://github.com/citusdata/pg_cron.git && \
    cd pg_cron && \
    make && \
    make install