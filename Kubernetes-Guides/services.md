## Motivation
If you write a pod definition with multiple containers in, they can communicate
together because they are in the same pod. A pod behaves as if it was a machine
with its own IP address. Each container on the pod is then assigned one local port of the pod (machine). If you deploy applications over multiple pods, they cannot
communicate with each other, because they don't "see" themselves on the network
without services. Services are used for this purpose, so the applications can be
exposed to the "outside world".

## ClusterIP
This type of service object allows you to expose a pod within the cluster. That
means only pod-to-pod communication. ClusterIP service will create an IP address
which will redirect any inbound traffic to the matching pods.

#### Use case scenario
In a deployment, you have an application based on client-server model. You deploy
some clients and one server, with the server being in it's own pod. The server is
crucial part, because without the server, clients can't communicate with each other.
You need to expose the server so the clients can reach the server.

#### ClusterIP service definition example
```
apiVersion: v1
kind: Service
metadata:
  name: application-clusterip
  labels:
    run: application-server
spec:
  type: ClusterIP
  ports:
  - name: clusterip
    protocol: TCP
    port: 50000
    targetPort: 50000
  selector:
    app: application-server
```
> **NOTE**: If the type is **clusterip**, it can be omitted from the service
definition, as this type is a default for service definition.

In the definition, you have to specify a selector based on which will k8s expose
every pod with matching selector. Port should have defined a protocol (TCP/UDP).
Port 50000 here is used as port of clusterIP and targetPort is used as a port on
which your application listens to. This way, anyone can reach the server application
via **ClusterIP:port**. This address will redirect the request to the **ServerPodIP:targetPort**, which is your server application.

#### Getting ClusterIP
```
# List all services
kubectl get svc

# List all endpoints
kubectl get ep
```

## NodePort
This type of service object allows you to expose a pod within the cluster and also
to the local network. That means, you can access an application running inside the
cluster from a node running on the same local network. This node does not have to
be connected to the cluster. NodePort service will create an ClusterIP address and
a NodePort on the machine which runs the pod.

#### Use case scenario
Let's use the same use case scenario as in ClusterIP, but this time, you also need
an access to the cluster from the local network.

#### NodePort service definition example
```
apiVersion: v1
kind: Service
metadata:
  name: application-nodeport
  labels:
    run: application-server
spec:
  type: NodePort
  ports:
  - name: nodeport
    protocol: TCP
    port: 50001
    targetPort: 50000
    nodePort: 32000
  selector:
    app: application-server
```

The definition is similar as in ClusterIP definition, but this time, nodePort 32000
is added. Let's say a node on which your server application runs has an IP of:
192.168.100.122. You can access the server application from any node on the local
network of 192.168.100.1/24 using the address 192.168.100.122:32000.

#### Getting NodePort
```
# List all services
kubectl get svc

# List all endpoints
kubectl get ep
```

## LoadBalancer
This type of service object allows you to expose a pod within the cluster and also
to the Internet. That means, you can access an application running inside the
cluster from anywhere in the world - it's public.

#### Use case scenario
Let's use the same use case scenario as in ClusterIP, but this time, you also need
an access to the cluster from the Internet.

#### LoadBalancer service definition example
```
apiVersion: v1
kind: Service
metadata:
  name: chatty-loadbalancer
  labels:
    run: chatty-server
#  annotations:
#    metallb.universe.tf/address-pool: production-public-ips
spec:
  type: LoadBalancer
  ports:
  - name: loadbalancer
    protocol: TCP
    port: 50002
    targetPort: 50000
    nodePort: 31000
  selector:
    app: chatty-server
#  loadBalancerIP: 192.168.122.195
```

> **TODO**: Deploy, test, explain. Locally it is available via ClusterIP and NodePort,
but it won't get externalIP and probably shouldn't. Needs more investigation.

#### Getting NodePort
> **TODO**:
