#!/bin/bash

howto(){
  echo "Usage: oc-ports.sh -n <namespace> -p <pod> -a (all namespaces & pods)" 
  echo "Example: oc-ports.sh -n openshift-storage"
  echo "Example: oc-ports.sh -n openshift-storage -p rook-ceph-operator-85d47cf975-l69r4"
  echo "Example: oc-ports.sh -a"
}

tcp_state(){
case $listen in
01)
listen="TCP_ESTABLISHED"
;;
02)
listen="TCP_SYN_SENT"
;;
03)
listen="TCP_SYN_RECV"
;;
04)
listen="TCP_FIN_WAIT1"
;;
05)
listen="TCP_FIN_WAIT2"
;;
06)
listen="TCP_TIME_WAIT"
;;
07)
listen="TCP_CLOSE"
;;
08)
listen="TCP_CLOSE_WAIT"
;;
09)
listen="TCP_LAST_ACK"
;;
0A)
listen="TCP_LISTEN"
;;
0B)
listen="TCP_CLOSING"
;;
0C)
listen="TCP_NEW_SYN_RECV"
;;
*)
listen="UKNOWN"
;;
esac
}

getsocketdetails(){
  format="%-15s%-15s%-15s%-15s%-12s%-20s%-50s%-30s\n"
  sockets=`oc exec -q $pod -n $namespace -- grep -v "rem_address" /proc/net/tcp | awk '{ print $2":"$3":"$4":"$10 }'`
  printf "$format" LocalAddr LocalPort RemoteAddr RemotePort Inode PortState Namespace Pod
  printf "$format" --------- --------- ---------- ---------- --------- --------- --------- -----------
  for socket in $(echo $sockets)
  do
    IFS=':' read -r localaddr localport remoteaddr remoteport listen inode <<< $socket
    localaddr=$(printf "%d." $(echo $localaddr | sed 's/../0x& /g' | tr ' ' '\n' | tac) | sed 's/\.$/\n/')
    localport=$(echo $((0x$localport)))
    remoteaddr=$(printf "%d." $(echo $remoteaddr | sed 's/../0x& /g' | tr ' ' '\n' | tac) | sed 's/\.$/\n/')
    remoteport=$(echo $((0x$remoteport)))
    tcp_state
    printf "$format" "$localaddr" "$localport" "$remoteaddr" "$remoteport" "$inode" "$listen" "$namespace" "$pod"
  done
  printf "$format" " "
}

all=0
while getopts n:p:ah option
do
case "${option}"
in
n) namespace=${OPTARG};;
p) pod=${OPTARG};;
a) all=1;;
h) howto; exit 0;;
\?) howto; exit 1;;
esac
done

if ([ -z "$namespace" ] && [ "$all" -eq "0" ]) then
   howto
   exit 1
fi

if ([ -z "$namespace" ] && [ -z "$pod" ] && [ "$all" -eq "1" ]);
   then
   for namespace in `oc get namespaces | egrep -v NAME | awk {'print $1'}`
   do
     for pod in `oc get pods -n $namespace | egrep -v NAME | grep Running | awk {'print $1'}`
     do 
       getsocketdetails
     done
   done
elif ([ -z "$pod" ] && [ "$all" -eq "0" ]);
   then
   for pod in `oc get pods -n $namespace | egrep -v NAME | grep Running | awk {'print $1'}`
   do
     getsocketdetails
   done

elif ([ "$all" -eq "0" ]);
   then
   getsocketdetails
else
   howto
   exit 1
fi
exit
