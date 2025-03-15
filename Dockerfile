# Stage 1: Build Caddy with Coraza WAF using xcaddy
FROM caddy:2-builder AS builder

WORKDIR /build

# Build Caddy with Coraza WAF, including the no_fs_access tag
RUN xcaddy build --with github.com/corazawaf/coraza-caddy/v2
    
FROM caddy:2-alpine

COPY --from=builder /build/caddy /usr/bin/caddy
RUN mkdir -p /etc/coraza/rules/owasp_crs
WORKDIR /srv

# Expose necessary ports
EXPOSE 80 443

VOLUME /config
VOLUME /data

# Set the entrypoint to run Caddy
ENTRYPOINT ["/usr/bin/caddy"]
CMD ["run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]