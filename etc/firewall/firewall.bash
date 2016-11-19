#!/bin/bash

#  Copyright 2012, Victor Arribas (v.arribas.urjc@gmail.com)
#
#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.


### BEGIN INIT INFO
# Provides: firewall
# Required-Start: $time
# Required-Stop:
# X-Start-Before: networking
# X-Stop-After: networking
# Default-Start: S
# Default-Stop: 0 6
# Short-Description: Firewall rules setup
# Description: Set/unset firewall rules (iptables)
### END INIT INFO


RETVAL=0
. /lib/lsb/init-functions
. /etc/default/firewall

msg_ini=log_action_begin_msg
msg_end=log_action_end_msg


#Scripts iptables
IPFW_RULES_DEFAULT=$IPFW_DIR/rules-default.bash
IPFW_RULES_LOCK=$IPFW_DIR/rules-lock.bash
IPFW_FLUSH=$IPFW_DIR/flush.bash


start() {
	start_mode $IPFW_RULES_DEFAULT
}

start() {
	$msg_ini "Setting IP-Tables Rules"
	bash $IPFW_RULES_DEFAULT 1>/dev/null 2>$FILE_ERR
	if [ "$(cat "$FILE_ERR")" == "" ]; then
		$msg_end 0
		rm "$FILE_ERR"
		RETVAL=0
	else
		$msg_end 1
		RETVAL=1
	fi
}


stop() {
	$msg_ini "Clearing IP-Tables Rules"
	bash $IPFW_FLUSH 1>/dev/null 2>$FILE_ERR
	if [ "$(cat "$FILE_ERR")" == "" ]; then
		$msg_end 0
		rm "$FILE_ERR"
		RETVAL=0
	else
		$msg_end 1
		RETVAL=1
	fi
}


change_mode() { # need $2
	bash $IPFW_FLUSH 1>/dev/null 2>/dev/null
	case $1 in
		default)
			start
			;;
		lock)
			IPFW_RULES_DEFAULT=$IPFW_RULES_LOCK
			start
			;;
		off)
			;;
		*)
			echo "Usage: firewall {default|lock|off}">&2
			;;
	esac
}


case $1 in
	start)
		start
		;;
	stop)
		stop
		;;
	restart)
		stop
		start
		;;
	status)
		/sbin/iptables -nvL
#		/sbin/iptables -t nat -nvL
		RETVAL=0
		;;
	change-mode)
		change_mode $2
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status|change-mode [default|lock|off]}" >&2
		REVAL=1
		;;
esac


exit $RETVAL
