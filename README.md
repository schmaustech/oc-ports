# oc-ports


Show all ports running inside of all containers on OpenShift cluster

~~~bash
#!/bin/bash
for i in `oc get pods -A | egrep -v "NAMESPACE|Completed"| awk {'print $1":"$2'}`
do 
namespace=`echo $i |cut -f1 -d:`
pod=`echo $i |cut -f2 -d:`
echo "$namespace---$pod"
oc exec $pod -n $namespace -- grep -v "rem_address" /proc/net/tcp  | awk 'function hextodec(str,ret,n,i,k,c){; done
    ret = 0
    n = length(str)
    for (i = 1; i <= n; i++) {
        c = tolower(substr(str, i, 1))
        k = index("123456789abcdef", c)
        ret = ret * 16 + k
    }
    return ret
} {x=hextodec(substr($2,index($2,":")-2,2)); for (i=5; i>0; i-=2) x = x"."hextodec(substr($2,i,2))}{print x":"hextodec(substr($2,index($2,":")+1,4))}'
done
~~~

Example output:

~~~bash
$ bash oc-ports.sh 
hive---hive-clustersync-0
10.128.0.156:42442
hive---hive-controllers-f698c9445-g5j7g
10.130.0.127:59126
hive---hiveadmission-6cb9df5647-49nhc
10.128.0.92:36534
hive---hiveadmission-6cb9df5647-pszl2
10.130.0.39:56864
multicluster-engine---agentinstalladmission-5dcb7d9d-2gpc4
10.130.0.139:42292
multicluster-engine---agentinstalladmission-5dcb7d9d-r8mcp
10.129.0.212:53114
multicluster-engine---assisted-image-service-0
command terminated with exit code 1
multicluster-engine---assisted-service-5b65cfd866-sp2vs
Defaulted container "assisted-service" out of: assisted-service, postgres
0.0.0.0:5432
10.129.0.211:32818
multicluster-engine---cluster-curator-controller-794d478684-4t6bx
10.130.0.117:44812
multicluster-engine---cluster-curator-controller-794d478684-55m2p
10.129.0.168:60058
multicluster-engine---cluster-manager-64569777f9-d7r8j
10.129.0.169:51144
multicluster-engine---cluster-manager-64569777f9-flvwr
10.128.0.148:39316
multicluster-engine---cluster-manager-64569777f9-r8942
10.130.0.118:33922
multicluster-engine---clusterclaims-controller-67796fb7d6-4kb97
Defaulted container "clusterclaims-controller" out of: clusterclaims-controller, clusterpools-delete-controller
^C
~~~
