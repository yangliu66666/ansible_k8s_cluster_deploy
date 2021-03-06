
#### 项目目录结构
```
ansible_k8s_cluster_deploy
├── add_node.yml
├── binary_pkg
│   ├── cni-plugins-linux-amd64-v0.8.5.tgz
│   ├── docker-18.09.9.tgz
│   ├── etcd-v3.3.13-linux-amd64.tar.gz
│   ├── kubernetes-server-linux-amd64.tar.gz
│   └── nginx-1.16.1.tar.gz
├── group_vars
│   └── all.yml
├── hosts
├── multiple_run.yml
├── plugins_images
│   ├── coredns-v1.6.7.tar
│   ├── dashboard-v2.0.0-beta8.tar
│   ├── flannel-v0.11.0-amd64.tar
│   ├── metrics-scraper-v1.0.1.tar
│   ├── nginx-ingress-controller-v0.30.0.tar
│   └── pause-amd64-3.0.tar
├── README.md
├── roles
│   ├── k8s-docker
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── daemon.json.j2
│   │       └── docker.service.j2
│   ├── k8s-etcd
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── etcd.conf.j2
│   │       └── etcd.service.j2
│   ├── k8s-ha
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── check_nginx_status.sh
│   │       ├── keepalived.conf
│   │       ├── nginx.conf
│   │       └── nginx.service
│   ├── k8s-master
│   │   ├── files
│   │   │   ├── apiserver-to-kubelet-rbac.yaml
│   │   │   └── token.csv
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── kube-apiserver.conf
│   │       ├── kube-apiserver.service
│   │       ├── kube-controller-manager.conf
│   │       ├── kube-controller-manager.service
│   │       ├── kube-scheduler.conf
│   │       └── kube-scheduler.service
│   ├── k8s-node
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── bootstrap.kubeconfig
│   │       ├── kubelet.conf
│   │       ├── kubelet-config.yml
│   │       ├── kubelet.service
│   │       ├── kube-proxy.conf
│   │       ├── kube-proxy-config.yml
│   │       ├── kube-proxy.kubeconfig
│   │       └── kube-proxy.service
│   ├── k8s-plugins
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── coredns.yaml
│   │       ├── kube-flannel.yaml
│   │       ├── kube-ui.yaml
│   │       └── nginx-ingress-controller.yaml
│   ├── k8s-tls
│   │   ├── files
│   │   │   ├── cfssl.tar.gz
│   │   │   ├── etcd-ca
│   │   │   │   ├── ca-config.json
│   │   │   │   └── ca-csr.json
│   │   │   ├── k8s-ca
│   │   │   │   ├── ca-config.json
│   │   │   │   └── ca-csr.json
│   │   │   └── kube-proxy-csr.json
│   │   ├── tasks
│   │   │   └── main.yml
│   │   └── templates
│   │       ├── etcd-csr.json.j2
│   │       └── kube-apiserver-csr.json.j2
│   └── sys-init
│       ├── tasks
│       │   └── main.yml
│       └── templates
│           └── hosts.j2
└── single_or_cloud-run.yml
```

#### 文件说明
```
hosts: 存放主机分组信息
roles: 项目的角色目录(主要代码)
binary_pkg: 存放项目所使用的压缩包
group_vars: 存放项目使用的全局变量
plugins_images： 存放项目的插件所使用的docker镜像包
```

#### 使用
```
# 安装ansible工具
yum -y install ansible

# 在项目根目录下创建二进制压缩包存放目录
cd ansible_k8s_cluster_deploy && mkdir binary_pkg

# 在项目根目录下创建插件镜像文件压缩包存放目录
cd ansible_k8s_cluster_deploy && mkdir plugins_images

#下载所需版本的kubernetes二进制包到binary_pkg目录下
wget -O ansible_k8s_cluster_deploy/binary_pkg/kubernetes-server-linux-amd64.tar.gz  https://storage.googleapis.com/kubernetes-release/release/v1.16.7/kubernetes-server-linux-amd64.tar.gz

#下载所需版本的etcd二进制包到binary_pkg目录下
wget -O ansible_k8s_cluster_deploy/binary_pkg/etcd-v3.3.13-linux-amd64.tar.gz https://github.com/etcd-io/etcd/releases/download/v3.3.13/etcd-v3.3.13-linux-amd64.tar.gz

#下载所需版本的cni插件二进制包到binary_pkg目录下
wget -O ansible_k8s_cluster_deploy/binary_pkg/cni-plugins-linux-amd64-v0.8.5.tgz https://github.com/containernetworking/plugins/releases/download/v0.8.5/cni-plugins-linux-amd64-v0.8.5.tgz

#下载所需版本的docker二进制包到binary_pkg目录下
wget -O ansible_k8s_cluster_deploy/binary_pkg/docker-18.09.9.tgz wget https://download.docker.com/linux/static/stable/x86_64/docker-18.09.9.tgz

#下载所需版本的nginx二进制包到binary_pkg目录下
wget -O ansible_k8s_cluster_deploy/binary_pkg/nginx-1.16.1.tar.gz http://nginx.org/download/nginx-1.16.1.tar.gz

# 如果网络好请忽略下面插件镜像文件的下载,否则请将以下镜像提前下载好保存到项目目录下的plugins_images目录下
liuyang666/nginx-ingress-controller:0.30.0
liuyang666/coredns:1.6.7
kubernetesui/dashboard:v2.0.0-beta8
kubernetesui/metrics-scraper:v1.0.1
liuyang666/flannel:v0.11.0-amd64
liuyang666/pause-amd64:3.0

# 使用之前先修改group_vars/all.yml中的相关信息

# 使用以下命令部署完成之后,集群中所有ssl证书都存放在项目根目录的ssl文件夹下 (请将ssl文件夹妥善保管和备份)

# 部署单个master或者多个master部署在公有云上:
ansible-playbook -i hosts single_or_cloud-run.yml -k

# 部署多个master:
ansible-playbook -i hosts multiple_run.yml -k


# 添加节点
修改hosts文件中的add_node组:
ansible-playbook -i hosts add_node.yml -k
```
