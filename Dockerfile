FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    SHELLINABOX_PORT=4200

# Enable universe (shellinabox is in universe on Ubuntu 22.04)
RUN sed -i 's/^# deb $$.*$$ universe/deb \1 universe/' /etc/apt/sources.list

# Install shellinabox and essentials with no recommends; clean up apt caches for smaller image
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      shellinabox ca-certificates curl wget nano sudo tzdata locales \
      # ensure login utilities are present for /:LOGIN
      login passwd \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set root password to "root" (for demo/dev only — do NOT use in production)
RUN echo 'root:root' | chpasswd

# Configure locales (avoid interactive tzdata/locales prompts)
RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Expose the web terminal port
EXPOSE 4200

# HEALTHCHECK to verify shellinabox is serving
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:${SHELLINABOX_PORT}/ >/dev/null 2>&1 || exit 1

# Run shellinaboxd:
# --no-ssl: disable SSL (use a reverse proxy/ingress TLS in production)
# -s "/:LOGIN": provide login prompt at root URL
# -p "${SHELLINABOX_PORT}": listen on configured port
CMD ["/usr/bin/shellinaboxd", "--no-ssl", "-s", "/:LOGIN", "-p", "4200"]
