#!/bin/sh
set -xe

# # first arg is `-f` or `--some-option`
# # or first arg is `something.conf`
# if [ "${1#-}" != "$1" ]; then
# 	set -- varnishd "$@"
# fi
#
# # allow the container to be started with `--user`
# if [ "$1" = 'redis-server' -a "$(id -u)" = '0' ]; then
# 	chown -R varnishd .
# 	exec su-exec redis "$0" "$@"
# fi
#
# exec "$@"



if [ "$1" = 'varnishd' ]; then
	pid=0
	pid2=0

	# SIGTERM-handler
	term_handler() {
		if [ $pid -ne 0 ]; then
			kill -SIGTERM "$pid"
			wait "$pid"
		fi

		if [ $pid2 -ne 0 ]; then
			kill -SIGTERM "$pid2"
			wait "$pid2"
		fi

		exit 143; # 128 + 15 -- SIGTERM
	}

	# setup handlers
	# on callback, kill the last background process, which is `tail -f /dev/null` and execute the specified handler
	trap 'kill ${!}; term_handler' SIGTERM

	# sleep ${VARNISH_D_DELAY:=10}
	# curl $VARNISH_BACKEND_IP:$VARNISH_BACKEND_PORT

	varnishd -f /etc/varnish/default.vcl \
					 -s malloc,${VARNISH_MEMORY:-'2G'} \
					 -n /var/lib/varnish \
					 -a ${VARNISH_IP:-'0.0.0.0'}:${VARNISH_PORT:-'8080'} \
					 -F -p cli_timeout=60 -p connect_timeout=60 &

	pid="$!"
	sleep 5

	if [ ${VARNISH_LOG:=0} -eq 1 ]; then
		echo "Starting log to console"
		varnishlog &
		pid2="$!"
	fi

	# wait indefinetely
	while true
	do
		tail -f /dev/null & wait ${!}
	done
else
	exec "$@"
fi
