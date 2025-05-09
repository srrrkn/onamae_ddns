FROM alpine:3.19

RUN apk add --no-cache bash curl openssl bind-tools

COPY onamae_ddns.sh /onamae_ddns.sh
RUN chmod +x /onamae_ddns.sh

ENTRYPOINT ["/onamae_ddns.sh"]