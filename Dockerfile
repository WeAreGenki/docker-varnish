# Varnish cache image for production

FROM alpine:3.4
MAINTAINER Max Milton <max@wearegenki.com>

RUN set -xe \
  && addgroup -g 3333 -S varnish \
  && adduser -D -u 3333 -S -h /var/cache/nginx -s /sbin/nologin -G varnish varnish \
  && mkdir -p /var/lib/varnish \
  && apk add --no-cache varnish \
  \
  # Forward logs to docker log collector
  && ln -sf /dev/stdout /var/log/varnish/varnishlog.log \
  && ln -sf /dev/stdout /var/log/varnish/default.log \
  && chown -R varnish /var/log/varnish /var/lib/varnish \
	\
	# Unset SUID on all files
	&& for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

COPY default.vcl /etc/varnish/default.vcl

USER varnish
EXPOSE 8080

CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-s", "malloc,128M", "-a", "0.0.0.0:8080"]
