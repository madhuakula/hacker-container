FROM golang:alpine as golang
LABEL NAME="Hacker Container" MAINTAINER="Madhu Akula"
RUN apk add --no-cache git \
    && go install github.com/aquasecurity/kube-bench@latest \
    && go install github.com/OJ/gobuster@latest \
    && git clone https://github.com/cyberark/kubeletctl \
    && cd kubeletctl && go install github.com/mitchellh/gox@latest \
    && go mod vendor && go fmt ./... && mkdir -p build \
    && if [ `uname -m` == "aarch64" ]; then ARCH="linux/arm64"; else ARCH="linux/amd64"; fi \
    && GOFLAGS=-mod=vendor gox -ldflags "-s -w" --osarch=$ARCH -output "build/kubeletctl_local_build"

FROM alpine:3.14
LABEL NAME="Hacker Container" MAINTAINER="Madhu Akula"

ENV DOCKER_VERSION=19.03.9
ENV KUBECTL_VERSION=1.18.3
ENV HELM_VERSION=3.2.2
ENV HELMV2_VERSION=2.16.7
ENV AUDIT2RBAC_VERSION=0.8.0
ENV AMICONTAINED_VERSION=0.4.9.4
ENV KUBESEC_VERSION=2.11.4
ENV CFSSL_VERSION=1.6.1.1
ENV AMASS_VERSION=3.6.3
ENV KUBECTL_WHOCAN_VERSION=0.4.0
ENV ETCDCTL_VERSION=3.4.9
ENV KUBEBENCH_VERSION=0.3.0
ENV GITLEAKS_VERSION=8.8.6
ENV TLDR_VERSION=0.6.1
ENV KUBEAUDIT_VERSION=0.17.0
ENV POPEYE_VERSION=0.9.0
ENV HADOLINT_VERSION=2.10.0
ENV CONFTEST_VERSION=0.21.0

WORKDIR /tmp

COPY --from=golang /go/bin/kube-bench /usr/local/bin/kube-bench
COPY --from=golang /go/bin/gobuster /usr/local/bin/gobuster
COPY --from=golang /go/kubeletctl/build/kubeletctl_local_build /usr/local/bin/kubeletctl

COPY pwnchart /root/pwnchart

RUN if [ `uname -m` == "aarch64" ]; then \
        apk --no-cache add \
        curl wget bash htop nmap nmap-scripts python3 python2 py3-pip ca-certificates bind-tools \
        coreutils iputils net-tools git unzip whois tcpdump openssl proxychains-ng procps zmap scapy \
        netcat-openbsd redis postgresql-client mysql-client masscan nikto ebtables perl-net-ssleay \
        && curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl \
        && mv kubectl /usr/local/bin/kubectl \
        && curl -fSLO https://github.com/Shopify/kubeaudit/releases/download/${KUBEAUDIT_VERSION}/kubeaudit_${KUBEAUDIT_VERSION}_linux_arm64.tar.gz \
        && tar -xvzf kubeaudit_${KUBEAUDIT_VERSION}_linux_arm64.tar.gz && mv kubeaudit /usr/local/bin/kubeaudit \
        && curl -fSLO https://github.com/derailed/popeye/releases/download/v${POPEYE_VERSION}/popeye_Linux_arm64.tar.gz \
        && tar -xvzf popeye_Linux_arm64.tar.gz && mv popeye /usr/local/bin/popeye \
        && curl -fSL https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-arm64 \
        -o /usr/local/bin/hadolint \
        && curl -fSLO https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz \
        && tar -xvzf conftest_${CONFTEST_VERSION}_Linux_arm64.tar.gz && mv conftest /usr/local/bin/conftest \
        && curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz \
        && tar -zxvf helm-v${HELM_VERSION}-linux-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/helm \
        && curl -LO https://get.helm.sh/helm-v${HELMV2_VERSION}-linux-arm64.tar.gz \
        && tar -zxvf helm-v${HELMV2_VERSION}-linux-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/helm2 \
        && curl -LO https://github.com/liggitt/audit2rbac/releases/download/v${AUDIT2RBAC_VERSION}/audit2rbac-linux-arm64.tar.gz \
        && curl -fSL https://github.com/adamhurm/amicontained/releases/download/v${AMICONTAINED_VERSION}/amicontained_linux_arm64 \
        -o /usr/local/bin/amicontained \
        && curl -fSLO https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_arm64.tar.gz \
        && tar -xvzf kubesec_linux_arm64.tar.gz && mv kubesec /usr/local/bin/kubesec \
        && curl -fSL https://github.com/adamhurm/cfssl/releases/download/v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_arm64 \
        -o /usr/local/bin/cfssl \
        && curl -fSLO https://github.com/OWASP/Amass/releases/download/v${AMASS_VERSION}/amass_linux_arm64.zip \
        && unzip amass_linux_arm64.zip && mv amass_linux_arm64/amass /usr/local/bin/amass \
        && mv amass_linux_arm64/examples/wordlists /usr/share/wordlists \
        && curl -fSL https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -o /usr/share/wordlists/rockyou.txt.tar.gz \
        && curl -fSLO https://github.com/aquasecurity/kubectl-who-can/releases/download/v${KUBECTL_WHOCAN_VERSION}/kubectl-who-can_linux_arm64.tar.gz \
        && tar -xvzf kubectl-who-can_linux_arm64.tar.gz \
        && mv kubectl-who-can /usr/local/bin/kubectl-who-can \
        && curl -fSLO https://download.docker.com/linux/static/stable/aarch64/docker-${DOCKER_VERSION}.tgz \
        && tar -xvzf docker-${DOCKER_VERSION}.tgz && mv docker/* /usr/local/bin/ \
        && curl -fsLO https://github.com/isacikgoz/tldr/releases/download/v${TLDR_VERSION}/tldr_${TLDR_VERSION}_linux_arm64.tar.gz \
        && tar -xvzf tldr_${TLDR_VERSION}_linux_arm64.tar.gz && mv tldr /usr/local/bin/ \
        && curl -fSLO https://github.com/etcd-io/etcd/releases/download/v${ETCDCTL_VERSION}/etcd-v${ETCDCTL_VERSION}-linux-arm64.tar.gz \
        && tar -xvzf etcd-v${ETCDCTL_VERSION}-linux-arm64.tar.gz && mv etcd-v${ETCDCTL_VERSION}-linux-arm64/etcdctl /usr/local/bin/  \
        && git clone https://github.com/docker/docker-bench-security.git /root/docker-bench-security \
        && git clone https://github.com/CISOfy/lynis /root/lynis \
        && git clone --depth 1 https://github.com/drwetter/testssl.sh.git /usr/share/testssl \
        && ln -s /usr/share/testssl/testssl.sh /usr/local/bin/testssl \
        && curl -fSLO https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks_${GITLEAKS_VERSION}_linux_arm64.tar.gz \
        && tar -xzvf gitleaks_${GITLEAKS_VERSION}_linux_arm64.tar.gz \
        && mv gitleaks /usr/local/bin/gitleaks \
        && curl -fSL https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -o /usr/local/bin/linenum \
        && git clone --depth 1 https://github.com/pentestmonkey/unix-privesc-check.git /root/unix-privesc-check \
        && curl -fSL https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -o /usr/local/bin/linux-exploit-suggester \
        && curl -fSL https://raw.githubusercontent.com/mbahadou/postenum/master/postenum.sh -o /usr/local/bin/postenum \
        && git clone https://github.com/aquasecurity/kube-hunter /root/kube-hunter \
        && chmod a+x /usr/local/bin/linenum /usr/local/bin/linux-exploit-suggester /usr/local/bin/cfssl /usr/local/bin/hadolint /usr/local/bin/conftest \
        /usr/local/bin/postenum /usr/local/bin/gitleaks /usr/local/bin/kubectl /usr/local/bin/amicontained /usr/local/bin/kubeaudit /usr/local/bin/popeye /usr/local/bin/kubeletctl \
        && pip3 install --no-cache-dir awscli truffleHog \
        && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
        && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
        && apk update && apk add mongodb yaml-cpp=0.6.2-r2 \
        && ln -s /lib/ld-musl-aarch64.so.1  /lib/ld-linux-aarch64.so.1 \
        && rm -rf /tmp/* ; \
    else \
        RUN apk --no-cache add \
        curl wget bash htop nmap nmap-scripts python3 python2 py3-pip ca-certificates bind-tools \
        coreutils iputils net-tools git unzip whois tcpdump openssl proxychains-ng procps zmap scapy \
        netcat-openbsd redis postgresql-client mysql-client masscan nikto ebtables perl-net-ssleay \
        && curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
        && mv kubectl /usr/local/bin/kubectl \
        && curl -fSLO https://github.com/Shopify/kubeaudit/releases/download/v${KUBEAUDIT_VERSION}/kubeaudit_${KUBEAUDIT_VERSION}_linux_amd64.tar.gz \
        && tar -xvzf kubeaudit_${KUBEAUDIT_VERSION}_linux_amd64.tar.gz && mv kubeaudit /usr/local/bin/kubeaudit \
        && curl -fSLO https://github.com/derailed/popeye/releases/download/v${POPEYE_VERSION}/popeye_Linux_x86_64.tar.gz \
        && tar -xvzf popeye_Linux_x86_64.tar.gz && mv popeye /usr/local/bin/popeye \
        && curl -fSL https://github.com/hadolint/hadolint/releases/download/v${HADOLINT_VERSION}/hadolint-Linux-x86_64 \
        -o /usr/local/bin/hadolint \
        && curl -fSLO https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz \
        && tar -xvzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz && mv conftest /usr/local/bin/conftest \
        && curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
        && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm \
        && curl -LO https://get.helm.sh/helm-v${HELMV2_VERSION}-linux-amd64.tar.gz \
        && tar -zxvf helm-v${HELMV2_VERSION}-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/helm2 \
        && curl -LO https://github.com/liggitt/audit2rbac/releases/download/v${AUDIT2RBAC_VERSION}/audit2rbac-linux-amd64.tar.gz \
        && curl -fSL https://github.com/genuinetools/amicontained/releases/download/v${AMICONTAINED_VERSION}/amicontained-linux-amd64 \
        -o /usr/local/bin/amicontained \
        && curl -fSLO https://github.com/controlplaneio/kubesec/releases/download/v${KUBESEC_VERSION}/kubesec_linux_amd64.tar.gz \
        && tar -xvzf kubesec_linux_amd64.tar.gz && mv kubesec /usr/local/bin/kubesec \
        && curl -fSL https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/cfssl_${CFSSL_VERSION}_linux_amd64 \
        -o /usr/local/bin/cfssl \
        && curl -fSLO https://github.com/OWASP/Amass/releases/download/v${AMASS_VERSION}/amass_linux_amd64.zip \
        && unzip amass_linux_amd64.zip && mv amass_linux_amd64/amass /usr/local/bin/amass \
        && mv amass_linux_amd64/examples/wordlists /usr/share/wordlists \
        && curl -fSL https://github.com/danielmiessler/SecLists/raw/master/Passwords/Leaked-Databases/rockyou.txt.tar.gz \
        -o /usr/share/wordlists/rockyou.txt.tar.gz \
        && curl -fSLO https://github.com/aquasecurity/kubectl-who-can/releases/download/v${KUBECTL_WHOCAN_VERSION}/kubectl-who-can_linux_x86_64.tar.gz \
        && tar -xvzf kubectl-who-can_linux_x86_64.tar.gz \
        && mv kubectl-who-can /usr/local/bin/kubectl-who-can \
        && curl -fSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_VERSION}.tgz \
        && tar -xvzf docker-${DOCKER_VERSION}.tgz && mv docker/* /usr/local/bin/ \
        && curl -fsLO https://github.com/isacikgoz/tldr/releases/download/v${TLDR_VERSION}/tldr_${TLDR_VERSION}_linux_amd64.tar.gz \
        && tar -xvzf tldr_${TLDR_VERSION}_linux_amd64.tar.gz && mv tldr /usr/local/bin/ \
        && curl -fSLO https://github.com/etcd-io/etcd/releases/download/v${ETCDCTL_VERSION}/etcd-v${ETCDCTL_VERSION}-linux-amd64.tar.gz \
        && tar -xvzf etcd-v${ETCDCTL_VERSION}-linux-amd64.tar.gz && mv etcd-v${ETCDCTL_VERSION}-linux-amd64/etcdctl /usr/local/bin/  \
        && git clone https://github.com/docker/docker-bench-security.git /root/docker-bench-security \
        && git clone https://github.com/CISOfy/lynis /root/lynis \
        && git clone --depth 1 https://github.com/drwetter/testssl.sh.git /usr/share/testssl \
        && ln -s /usr/share/testssl/testssl.sh /usr/local/bin/testssl \
        && curl -fSL https://github.com/zricethezav/gitleaks/releases/download/v${GITLEAKS_VERSION}/gitleaks-linux-amd64 -o /usr/local/bin/gitleaks \
        && curl -fSL https://raw.githubusercontent.com/rebootuser/LinEnum/master/LinEnum.sh -o /usr/local/bin/linenum \
        && git clone --depth 1 https://github.com/pentestmonkey/unix-privesc-check.git /root/unix-privesc-check \
        && curl -fSL https://raw.githubusercontent.com/mzet-/linux-exploit-suggester/master/linux-exploit-suggester.sh -o /usr/local/bin/linux-exploit-suggester \
        && curl -fSL https://raw.githubusercontent.com/mbahadou/postenum/master/postenum.sh -o /usr/local/bin/postenum \
        && git clone https://github.com/aquasecurity/kube-hunter /root/kube-hunter \
        && chmod a+x /usr/local/bin/linenum /usr/local/bin/linux-exploit-suggester /usr/local/bin/cfssl /usr/local/bin/hadolint /usr/local/bin/conftest \
        /usr/local/bin/postenum /usr/local/bin/gitleaks /usr/local/bin/kubectl /usr/local/bin/amicontained /usr/local/bin/kubeaudit /usr/local/bin/popeye /usr/local/bin/kubeletctl \
        && pip3 install --no-cache-dir awscli truffleHog \
        && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
        && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
        && apk update && apk add mongodb yaml-cpp=0.6.2-r2 \
        && rm -rf /tmp/* ; \
    fi

WORKDIR /root

CMD [ "/bin/sh" ]
