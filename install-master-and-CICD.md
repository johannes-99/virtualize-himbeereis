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

```
git clone https://github.com/johannes-99/virtualize-himbeereis.git
./cluster/deploy-cluster.sh
./cluster/do-hosts-fake-dns.sh 
# on windows do this manually in the hosts file:
	192.168.178.36 gitea drone myregistry #raspi 
	#OR 
	#172.30.0.2 gitea drone myregistry #wsl2

```

# gitea & drone setup 
if run for first time (no DB or volumes available): 
 * go to http://gitea in browser on windows and do initial setup:
 * leave Gitea-HTTP-Listen-Port on 3000
 * change Gitea-Basis-URL to http://gitea/ (TODO: add ssh info )
 * setup new mirror (via migration) for github repo
 * create token for drone.io:  http://gitea/user/settings/applications (Name der Anwendung: drone, Weiterleitungs-URI: http://drone/login ) and provide credentials via drone container env variables
 * goto http://drone and do initial setup (redirects to gitea)


