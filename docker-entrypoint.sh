#!/bin/bash
set -e

if [ "$1" = 'trytond' ]; then
	# Listen on all interfaces
	sed -i "/^#listen = \[::\]:8000/s/^#//" "$TRYTOND_CONFIG"
	# Enable default admin password to be able to create databases from the client out of the box
	# sed -i "/^#super_pwd = jkUbZGvFNeugk/s/^#//" $TRYTOND_CONFIG
	
	if [ "$TRYTOND_PASSWORD" ]; then
		echo "$TRYTOND_PASSWORD" > $TRYTONPASSFILE
	else
		cat >&2 <<-'EOWARN'
			****************************************************
			WARNING: No password has been set for the server.
				 A password for the server is needed to be able
				 to manage databases from the Tryton client.
				 
				 Use "-e TRYTOND_PASSWORD=password" to set
				 it in "docker run".
			****************************************************
		EOWARN
	fi
	
	# Run setup scripts for the server
	if [ -d /docker-entrypoint-init.d ]; then
		for f in /docker-entrypoint-init.d/*.sh; do
			[ -f "$f" ] && . "$f"
		done
	fi
	
	# Reset permissions to the data directory
	chown -R tryton:tryton "$TRYTOND_DATA"
	
	exec gosu tryton /usr/bin/trytond -c $TRYTOND_CONFIG -v
fi

exec "$@"
