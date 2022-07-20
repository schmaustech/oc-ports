# **Walk OpenShift Ports in All Containers**

The following script will show all local,remote and port connections running in all pods in all namespaces on an OpenShift cluster.

~~~bash
#!/bin/bash
format="%-15s%-15s%-15s%-15s%-12s%-12s%-30s%-30s\n"
for namespace in `oc get namespaces | egrep -v NAME | awk {'print $1'}`
do
  for pod in `oc get pods -n $namespace | egrep -v NAME | grep Running | awk {'print $1'}`
  do 
    sockets=`oc exec -q $pod -n $namespace -- grep -v "rem_address" /proc/net/tcp | awk '{ print $2":"$3":"$4":"$10 }'`
    printf "$format" LocalAddr LocalPort RemoteAddr RemotePort ProcessID Listener Namespace Pod
    printf "$format" --------- --------- ---------- ---------- --------- -------- --------- -----------
    for socket in $(echo $sockets)
    do
      IFS=':' read -r localaddr localport remoteaddr remoteport listen inode <<< $socket
      localaddr=$(printf "%d." $(echo $localaddr | sed 's/../0x& /g' | tr ' ' '\n' | tac) | sed 's/\.$/\n/')
      localport=$(echo $((0x$localport)))
      remoteaddr=$(printf "%d." $(echo $remoteaddr | sed 's/../0x& /g' | tr ' ' '\n' | tac) | sed 's/\.$/\n/')
      remoteport=$(echo $((0x$remoteport)))
      processid=$(oc exec -q -i $pod -n $namespace -- bash -s <<EOF
find /proc/*/fd/* -type l 2>/dev/null | xargs ls -l 2>/dev/null | grep 'socket:\[$inode\]' | cut -d ' ' -f9| cut -d '/' -f3 
EOF
)
      if [ "$listen" = "0A" ]; then
        listen=$(echo $listen - YES) 
      else
        listen=$(echo $listen - NO)
      fi
      printf "$format" "$localaddr" "$localport" "$remoteaddr" "$remoteport" "$processid" "$listen" "$namespace" "$pod"
    done
  done
done

~~~

Example output:

~~~bash
 bash oc-ports.sh 
No resources found in default namespace.
No resources found in kube-node-lease namespace.
No resources found in kube-public namespace.
No resources found in kube-system namespace.
No resources found in openshift namespace.
LocalAddr      LocalPort      RemoteAddr     RemotePort     ProcessID   Listener    Namespace                     Pod                           
---------      ---------      ----------     ----------     ---------   --------    ---------                     -----------                   
10.128.0.35    59840          172.30.0.1     443                        01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33374          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33368          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33366          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33360          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33348          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33346          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33356          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33370          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    59598          172.30.0.1     443            1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33354          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33362          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
10.128.0.35    33372          192.168.0.206  2379           1           01 - NO     openshift-apiserver           apiserver-7bffb54867-4qsg6    
LocalAddr      LocalPort      RemoteAddr     RemotePort     ProcessID   Listener    Namespace                     Pod                           
---------      ---------      ----------     ----------     ---------   --------    ---------                     -----------                   
10.128.0.15    34790          172.30.0.1     443            1           01 - NO     openshift-apiserver-operator  openshift-apiserver-operator-646c767754-pdq9z
LocalAddr      LocalPort      RemoteAddr     RemotePort     ProcessID   Listener    Namespace                     Pod                           
---------      ---------      ----------     ----------     ---------   --------    ---------                     -----------                   
10.128.0.83    53022          172.30.0.1     443            1           01 - NO     openshift-authentication      oauth-openshift-86cd9cb5b7-wgb56
LocalAddr      LocalPort      RemoteAddr     RemotePort     ProcessID   Listener    Namespace                     Pod                           
---------      ---------      ----------     ----------     ---------   --------    ---------                     -----------                   
10.128.0.6     55796          192.168.0.206  6443           1           01 - NO     openshift-authentication-operatorauthentication-operator-6d78567558-hsrwr
10.128.0.6     56544          192.168.0.206  6443           1           01 - NO     openshift-authentication-operatorauthentication-operator-6d78567558-hsrwr
10.128.0.6     39748          172.30.0.1     443            1           01 - NO     openshift-authentication-operatorauthentication-operator-6d78567558-hsrwr
10.128.0.6     57264          192.168.0.206  6443           1           01 - NO     openshift-authentication-operatorauthentication-operator-6d78567558-hsrwr
No resources found in openshift-cloud-controller-manager namespace.
LocalAddr      LocalPort      RemoteAddr     RemotePort     ProcessID   Listener    Namespace                     Pod                           
---------      ---------      ----------     ----------     ---------   --------    ---------                     -----------                   
127.0.0.1      8797           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      10248          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        9641           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        9642           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      9259           0.0.0.0        0              1           0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  9643           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      9260           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  9100           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      9100           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      6060           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  9644           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      29102          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      29103          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        111            0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        80             0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      29105          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      4180           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        53             0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        22             0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
127.0.0.1      9977           0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  10010          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        443            0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
0.0.0.0        52539          0.0.0.0        0                          0A - YES    openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  42866          192.168.0.206  2379                       01 - NO     openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  43084          192.168.0.206  2379                       01 - NO     openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  42554          192.168.0.206  2379                       01 - NO     openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
192.168.0.206  43212          192.168.0.206  2379                       01 - NO     openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48
10.128.0.2     38162          10.128.0.83    6443                       06 - NO     openshift-cloud-controller-manager-operatorcluster-cloud-controller-manager-operator-544877fff-gbz48

~~~
