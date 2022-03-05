# Setup master node on raspi

Execute all commands as root:

**Install ubuntu on raspi:** On windows, use raspberry pi imager to put ubuntu on SD card: Ubuntu Server 20.04.xx LTS 64 bit 


```
apt update
apt upgrade
```

```
hostnamectl set-hostname "k3s-master"
```

```
add this at the end of the first line of /boot/firmware/cmdline.txt":
 cgroup_enable=cpuset cgroup_enable=memory cgroup_memory=1
```
```
reboot
```

**To fix a problem (on raspi only) if connection to cluster flight control not possible:**
seems this is not needed any more:
~~sudo apt install linux-modules-extra-raspit~~ 


**Install k3s**

```
curl -sfL https://get.k3s.io | sh -
systemctl status k3s
kubectl get node
```
 
[kubectl cheat sheet](https://kubernetes.io/docs/reference/kubectl/cheatsheet/)

**Prepare cluster deplyoment**

# make sure kubectl is linked to k3s-master 
kubectl cluster-info

copy k3s-master:/etc/rancher/k3s/cat k3s.yaml to wsl2:/home/ubuntu/.kube/config 
and change ip addr to k3s-master ip (e.g.:  server: https://127.0.0.1:6443 to  server: https://192.168.178.36:6443)

```

git clone https://github.com/johannes-99/virtualize-himbeereis.git
cd dev-helpers

#these scripts can be executed on wsl2 or k3s-master:
./deploy-cluster.sh //will throw errors due to missing secrets
./drone-secret-add-gitea-credentials.sh
./drone-secret-create-rpc.sh


#set fake hosts entry
./do-hosts-fake-dns.sh 
# on windows do this manually in the hosts file:
192.168.178.36 gitea drone myregistry #raspi 
#OR 
#172.30.0.2 gitea drone myregistry #wsl2

```
# argo setup

``` 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

```

# gitea & drone setup 
if run for first time (no DB or volumes available): 
 * go to http://gitea in browser on windows and do initial setup:
 * leave Gitea-HTTP-Listen-Port on 3000
 * Change Server-Domain to   gitea
 * change Gitea-Basis-URL to http://gitea/         (without port)
 * register user and setup new mirror (via migration) for repo https://github.com/johannes-99/nextcloud-service-python
 * create token for drone.io:  http://gitea/user/settings/applications (Name der Anwendung: drone, Weiterleitungs-URI: http://drone/login ) and provide credentials via drone container env variables ( drone-secret-add-gitea-credentials.sh and make sure drone pod uses new env variables via exec "echo $DRONE_GITEA_CLIENT_ID" inside the pod   )
 * goto http://drone and do initial setup (redirects to gitea)


