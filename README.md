# **Walk Open Ports in OpenShift Pods**

I was recently working with a customer who had the requirement to see what ports were in use inside a few of their OpenShift containers.  This led me to produce a little [script](https://github.com/schmaustech/oc-ports/blob/main/oc-ports.sh) that allows me to walk all the ports in use across a single namespace/pod, all pods in a given namespace or across the entire cluster.  Let's take a quick look at some examples of its usage in the rest of this short blog.

First let's demonstrate how to walk just a single namespace and pod.  In this example I will use the openshift-storage namespace and the rook-ceph-operator container.

~~~bash
$ ./oc-ports.sh -n openshift-storage -p rook-ceph-operator-85d47cf975-l69r4
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.128.1.31    52558          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47746          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47768          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    41142          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47742          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    41174          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47796          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47150          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47800          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    59690          172.30.51.97   3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47750          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    41158          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    52586          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    59816          172.30.244.234 443            786832572   TCP_ESTABLISHED     openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    37108          172.30.164.108 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47138          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    41096          172.30.244.234 443            816946818   TCP_ESTABLISHED     openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47752          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    41154          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    52568          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    55324          172.30.0.1     443            789789504   TCP_ESTABLISHED     openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    47782          172.30.132.190 3300           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
10.128.1.31    52576          10.130.0.71    6800           0           TCP_TIME_WAIT       openshift-storage                                 rook-ceph-operator-85d47cf975-l69r4
~~~

For our next test let's just provide a namespace and let the script enumerate through all the pods.  The output from this is quite lengthy so I will trunctate most of it.

~~~bash
$ ./oc-ports.sh -n openshift-machine-api
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
127.0.0.1      9191           0.0.0.0        0              205334      TCP_LISTEN          openshift-machine-api                             cluster-autoscaler-operator-5786c7584c-kvzfs
127.0.0.1      9191           127.0.0.1      59090          253479495   TCP_ESTABLISHED     openshift-machine-api                             cluster-autoscaler-operator-5786c7584c-kvzfs
10.129.0.51    41020          172.30.0.1     443            653600899   TCP_ESTABLISHED     openshift-machine-api                             cluster-autoscaler-operator-5786c7584c-kvzfs
127.0.0.1      59090          127.0.0.1      9191           253497374   TCP_ESTABLISHED     openshift-machine-api                             cluster-autoscaler-operator-5786c7584c-kvzfs
10.129.0.51    59338          172.30.0.1     443            669220775   TCP_ESTABLISHED     openshift-machine-api                             cluster-autoscaler-operator-5786c7584c-kvzfs
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.128.0.31    54666          172.30.0.1     443            789856883   TCP_ESTABLISHED     openshift-machine-api                             cluster-baremetal-operator-64f9997468-sj5xh
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.43    51300          172.30.0.1     443            548661167   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
10.130.0.43    46504          172.30.0.1     443            535870258   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
10.130.0.43    35602          172.30.0.1     443            548638559   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
10.130.0.43    46526          172.30.0.1     443            535879071   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
10.130.0.43    46552          172.30.0.1     443            535882997   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
10.130.0.43    46520          172.30.0.1     443            535868211   TCP_ESTABLISHED     openshift-machine-api                             machine-api-controllers-bf756c8f6-tsm69
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
127.0.0.1      8080           0.0.0.0        0              308875      TCP_LISTEN          openshift-machine-api                             machine-api-operator-8595794ccc-lvdd5
127.0.0.1      41508          127.0.0.1      8080           308168      TCP_ESTABLISHED     openshift-machine-api                             machine-api-operator-8595794ccc-lvdd5
127.0.0.1      8080           127.0.0.1      41508          329823      TCP_ESTABLISHED     openshift-machine-api                             machine-api-operator-8595794ccc-lvdd5
10.128.0.41    39462          172.30.0.1     443            789799809   TCP_ESTABLISHED     openshift-machine-api                             machine-api-operator-8595794ccc-lvdd5
10.128.0.41    54512          172.30.0.1     443            816812059   TCP_ESTABLISHED     openshift-machine-api                             machine-api-operator-8595794ccc-lvdd5
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
0.0.0.0        31815          0.0.0.0        0              632366      TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
127.0.0.1      10248          0.0.0.0        0              15033       TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
0.0.0.0        31625          0.0.0.0        0              612309      TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
192.168.0.111  10250          0.0.0.0        0              29659       TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
127.0.0.1      6060           0.0.0.0        0              55200       TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
192.168.0.111  9100           0.0.0.0        0              69903       TCP_LISTEN          openshift-machine-api                             metal3-6654b9c44c-4dgb2       
(...)
127.0.0.1      80             127.0.0.1      35180          0           TCP_TIME_WAIT       openshift-machine-api                             metal3-image-cache-tqrdq      
192.168.0.110  51874          192.168.0.112  2379           653534755   TCP_ESTABLISHED     openshift-machine-api                             metal3-image-cache-tqrdq      
10.129.0.1     54378          172.30.0.1     443            653518566   TCP_ESTABLISHED     openshift-machine-api                             metal3-image-cache-tqrdq      
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.129.0.58    36866          172.30.0.1     443            653597918   TCP_ESTABLISHED     openshift-machine-api                             metal3-image-customization-5c85d5f5f8-lbslg
~~~

Finally let's just run the command with the all option which will be even more output then our previous commands.  For troubleshooting one could redirect the output to a file if needed.  I went ahead and broke out of the run after a bit but the output gives one an idea of what they might see.

~~~bash
$ ./oc-ports.sh -a
No resources found in default namespace.
No resources found in kni22 namespace.
No resources found in kube-node-lease namespace.
No resources found in kube-public namespace.
No resources found in kube-system namespace.
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.31    34770          172.30.0.1     443            535870264   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-5bb4b4f75c-7t9pr   
10.130.0.31    56326          192.168.0.220  6443           548763858   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-5bb4b4f75c-7t9pr   
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.129.0.2     35954          172.30.0.1     443            653602954   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-registration-agent-7bb74955c9-7phlw
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.128.0.5     37114          172.30.0.1     443            789857695   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-registration-agent-7bb74955c9-n8nd9
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.32    55454          192.168.0.220  6443           543474785   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-registration-agent-7bb74955c9-rdsgw
10.130.0.32    59700          172.30.0.1     443            535874302   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-registration-agent-7bb74955c9-rdsgw
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.129.0.33    34538          172.30.0.1     443            653582074   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-work-agent-cc96bc45c-2hpgx
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.33    33190          172.30.0.1     443            535807747   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-work-agent-cc96bc45c-f8gwf
10.130.0.33    54940          192.168.0.220  6443           543910317   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-work-agent-cc96bc45c-f8gwf
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.128.0.7     37226          172.30.0.1     443            789858781   TCP_ESTABLISHED     open-cluster-management-agent                     klusterlet-work-agent-cc96bc45c-wmcnf
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.36    35850          172.30.0.1     443            543588502   TCP_ESTABLISHED     open-cluster-management-agent-addon               application-manager-8f8589977-jhzd4
                                                                                                                                                                            
LocalAddr      LocalPort      RemoteAddr     RemotePort     Inode       PortState           Namespace                                         Pod                           
---------      ---------      ----------     ----------     ---------   ---------           ---------                                         -----------                   
10.130.0.35    45864          172.30.0.1     443            538396535   TCP_ESTABLISHED     open-cluster-management-agent-addon               cert-policy-controller-fd4fd8d5d-vcxjh
                                                                                                                                                                            
^C
~~~

Hopefully this tool is useful in the future to anyone interested in connectivity among their pods in an OpenShift or Kubernetes cluster.
