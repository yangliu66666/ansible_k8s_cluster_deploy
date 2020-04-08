
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

# 注: 使用之前先修改group_vars/all.yml中的相关信息

# 使用以下命令部署完成之后,集群中所有ssl证书都存放在项目根目录的ssl文件夹下 (请将ssl文件夹妥善保管和备份)

# 部署单个master或者多个master部署在公有云上:
ansible-playbook -i hosts single_or_cloud-run.yml -k

# 部署多个master:
ansible-playbook -i hosts multiple_run.yml -k


# 添加节点
修改hosts文件中的add_node组:
ansible-playbook -i hosts add_node.yml -k
```
