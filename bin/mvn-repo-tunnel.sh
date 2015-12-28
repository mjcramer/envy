#!/bin/bash 

tunnel_pid=/tmp/tunnel-${USER}.pid

while getopts "h:u:l:r:t" opt; do
    case $opt in
    h)
        mvn_repo_tunnel_host=$OPTARG
		;;
    u)
        mvn_repo_tunnel_user=$OPTARG
		;;
    l)
        mvn_repo_tunnel_port_local=$OPTARG
		;;
    r)
        mvn_repo_tunnel_port_remote=$OPTARG
		;;
    t)
        exec=echo
        ;;
    \?)
        echo "Invalid option: -$opt" >&2
        exit 1
        ;;
    :)
        echo "Option -$opt requires an argument." >&2
        exit 1
        ;;
    esac
done
shift $(($OPTIND - 1))

if [ -z "${mvn_repo_tunnel_host}" ]; then
    mvn_repo_tunnel_host=jump01.prod.env.tout.com
fi

if [ -z "${mvn_repo_tunnel_user}" ]; then
    mvn_repo_tunnel_user=$(whoami)
fi

if [ -z "${mvn_repo_tunnel_port_local}" ]; then
    mvn_repo_tunnel_port_local=8081
fi

if [ -z "${mvn_repo_tunnel_port_remote}" ]; then
    mvn_repo_tunnel_port_remote=22081
fi


case $1 in 
	start)
		if [ -e ${tunnel_pid} ]; then
		    pid=$(cat ${tunnel_pid})
		    if [ -n "$(ps h ${pid})" ]; then
			    echo "Tunnel already running as process ${pid}."
			    exit 2
			else
			    $exec rm ${tunnel_pid}
			fi
		fi
		$exec ssh -nNT -L ${mvn_repo_tunnel_port_local}:localhost:${mvn_repo_tunnel_port_remote} ${mvn_repo_tunnel_user}@${mvn_repo_tunnel_host} &
		echo $! > ${tunnel_pid}
        echo "Tunnel started as process $(cat ${tunnel_pid})..."
		;;

	stop)
		if [ ! -e ${tunnel_pid} ]; then
			echo "No tunnel process to stop."
		else
            echo "Stopping tunnel..."
			$exec kill -9 $(cat ${tunnel_pid})
			$exec rm ${tunnel_pid}
		fi
		;;

    status)
		if [ -e ${tunnel_pid} ]; then
		    pid=$(cat ${tunnel_pid})
		    if [ -n "$(ps h ${pid})" ]; then
			    echo "Tunnel is running as process ${pid}."
                exit
			else
                echo "Stale pid file found at ${tunnel_pid}, removing..."
			    $exec rm ${tunnel_pid}
			fi
		fi
		echo "Tunnel is not active."
		;;

	*)
		echo "Usage: $0 <options> [start|stop|status]"
		;;
esac

