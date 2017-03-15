#!/bin/bash

tracedir=/sys/kernel/debug/tracing
opt_time=5

function usage {
  cat << END >&2
USAGE: trace_syscall [-t time] [lh] syscall:syscall:...
              -l list system calls
              -t time
              -h help
END

  exit
}

function warn_and_exit {
  echo >&2 "$@"
  exit 1
}

function stop_trace {
  echo 0 > $tracedir/tracing_on
}

function start_trace {
  IFS=:

  for syscall in $1; do
    syscall_dir=$(echo $syscall | sed 's/_/_enter_/g')
    echo enabling $syscall_dir
    echo 1 > $tracedir/events/syscalls/$syscall_dir/enable
  done
  echo 1 > $tracedir/tracing_on

}

function reset_trace {
  stop_trace
  echo > $tracedir/trace
  echo 0 > $tracedir/events/enable
}

while getopts :t:lh opt
do
  case $opt in
  t)  opt_time=$OPTARG ;;
  l)  opt_list=1 ;;
  h|?)  usage ;;
  :)  echo "Option -$OPTARG requires an argument." >&2
      exit 1
  esac
done

shift $(( $OPTIND - 1 ))

if (( $opt_list )); then
  ls -d $tracedir/events/syscalls/sys_enter* | sed 's/_enter//g' | xargs -I{} basename {}
  exit 1
fi

echo Timer...$opt_time

(( $# )) || usage
syscall=$1

ls $tracedir > /dev/null 2>&1 || warn_and_exit "Can't access $tracedir, are you root?"

reset_trace
echo "Starting trace"
start_trace $syscall
sleep $opt_time
echo "Stopping tracing"
stop_trace
cat $tracedir/trace
