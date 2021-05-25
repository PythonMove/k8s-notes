> **NOTE:** For now, just a list of misc commands that might be useful in future
>
```
# Check certificates expiry dates  
> kubeadm alpha certs check-expiration
[check-expiration] Reading configuration from the cluster...
[check-expiration] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'

CERTIFICATE                EXPIRES                  RESIDUAL TIME   CERTIFICATE AUTHORITY   EXTERNALLY MANAGED
admin.conf                 Nov 03, 2021 16:31 UTC   354d                                    no      
apiserver                  Nov 03, 2021 16:31 UTC   354d            ca                      no      
apiserver-etcd-client      Nov 03, 2021 16:31 UTC   354d            etcd-ca                 no      
apiserver-kubelet-client   Nov 03, 2021 16:31 UTC   354d            ca                      no      
controller-manager.conf    Nov 03, 2021 16:31 UTC   354d                                    no      
etcd-healthcheck-client    Nov 03, 2021 16:31 UTC   354d            etcd-ca                 no      
etcd-peer                  Nov 03, 2021 16:31 UTC   354d            etcd-ca                 no      
etcd-server                Nov 03, 2021 16:31 UTC   354d            etcd-ca                 no      
front-proxy-client         Nov 03, 2021 16:31 UTC   354d            front-proxy-ca          no      
scheduler.conf             Nov 03, 2021 16:31 UTC   354d                                    no      

CERTIFICATE AUTHORITY   EXPIRES                  RESIDUAL TIME   EXTERNALLY MANAGED
ca                      Nov 01, 2030 16:31 UTC   9y              no      
etcd-ca                 Nov 01, 2030 16:31 UTC   9y              no      
front-proxy-ca          Nov 01, 2030 16:31 UTC   9y              no      
```
> The command shows expiration/residual time for the client certificates in the **/etc/kubernetes/pki** folder and for the client certificate embedded in the KUBECONFIG files used by kubeadm (**admin.conf, controller-manager.conf and scheduler.conf**).
>
>Additionally, kubeadm informs the user if the certificate is externally managed; in this case, the user should take care of managing certificate renewal manually/using other tools.
>
```
# Adding/deleting roles
# kubectl label node <node-name> node-role.kubernetes.io/<role-name>=<role-name>

# Adding role "worker" to node "worker01"
> kubectl label node worker01 node-role.kubernetes.io/worker=worker

# Deleting role "worker" from node "worker01"
> kubcetl label node worker01 node-role.kubernetes.io/worker-
```
```
# Getting information about resources
# kubectl describe <pod|node>
```
```
# Create an Object
# kubectl apply -f <file-path>
> kubectl apply -f mariadb_deployment.yaml
```
```
# Execute command in container
# kubectl exec <pod-name> <options> -- <command>

# This command creates terminal in container and let you in
> kubectl exec <pod-name> -it -- /bin/bash
```
