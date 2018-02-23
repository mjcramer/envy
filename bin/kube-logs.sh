 7609  2018-02-11 21:30:07 kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c kubedns
 7610  2018-02-11 21:30:17 kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c dnsmasq
 7611  2018-02-11 21:30:30 kubectl logs --namespace=kube-system $(kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name) -c sidecar
 7612  2018-02-11 21:31:36 kubectl get pods --namespace=kube-system -l k8s-app=kube-dns -o name
 7613  2018-02-11 21:32:00 history | tail -5
 7614  2018-02-11 21:32:32 history | tail -6 > ~/envy/bin/kube-logs.sh
