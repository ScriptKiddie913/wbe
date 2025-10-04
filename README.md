# Web-based Ubuntu Shell (Ubuntu 22.04 + shellinabox)

A minimal Docker setup that exposes a web-based terminal (shellinabox) over HTTP on port 4200. Use for demos, labs, or controlled internal environments.

Important Security Notice
- This image enables root login with password "root". Do NOT expose to the public internet.
- For production, disable root login, use non-root users, enable TLS, and restrict access with a reverse proxy and proper auth.

Quick Start
- Build: docker build -t web-ubuntu-shell .
- Run: docker run --rm -p 4200:4200 web-ubuntu-shell
- Open: http://localhost:4200
- Login: user "root", password "root"

With docker-compose
- docker compose up --build
- Visit http://localhost:4200

Image Notes
- Base: ubuntu:22.04
- Installs: shellinabox, login/passwd tools, ca-certificates, curl, wget, nano, sudo, tzdata, locales
- Optimized with --no-install-recommends and apt cache cleanup
- Exposes port 4200
- HEALTHCHECK hits the HTTP endpoint

Customization
- Port: change SHELLINABOX_PORT env and EXPOSE as needed
- SSL/TLS: shellinabox supports SSL, but this image uses --no-ssl. Terminate TLS at a reverse proxy.
- Users: create a non-root user and disable root login for safer setups

Limitations on Vercel
- Vercel’s standard hosting is not a general-purpose VPS and does not run privileged Docker containers that expose arbitrary ports.
- This container is intended for container hosts that support long-lived processes and open TCP ports (e.g., your VM, Docker host, or other container platforms).
