# Varnish cache image for production

FROM alpine:3.4
MAINTAINER Max Milton <max@wearegenki.com>

RUN set -xe \
  && apk add --no-cache varnish \
  && sed -i -e"s/127.0.0.1:8080/0.0.0.0:80/g" /etc/conf.d/varnishd \
  \
  # Forward logs to docker log collector
  && ln -sf /dev/stdout /var/log/varnish/varnishlog.log \
  && ln -sf /dev/stdout /var/log/varnish/default.log \
	\
	# Unset SUID on all files
	&& for i in $(find / -perm /6000 -type f); do chmod a-s $i; done

COPY default.vcl /etc/varnish/default.vcl

USER varnish
EXPOSE 8080

CMD ["varnishd", "-F", "-f", "/etc/varnish/default.vcl", "-s", "malloc,128M", "-a", "0.0.0.0:8080"]
