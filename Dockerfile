FROM centos:7 as build
# CentOS golang build environment based on
# https://github.com/CentOS/CentOS-Dockerfiles/blob/master/golang/centos7/Dockerfile

RUN yum -y update && yum clean all

RUN mkdir -p /go && chmod -R 777 /go && \
    yum -y install hg git golang make
RUN yum clean all && rm -rf /var/cache/yum

ENV GOPATH /go

RUN mkdir -p /go/src/k8s.io/helm
WORKDIR /go/src/k8s.io/helm
COPY . .

RUN make build
RUN make docker-binary

FROM centos:7

COPY --from=build /go/src/k8s.io/helm/rootfs/tiller /usr/local/bin
COPY --from=build /go/src/k8s.io/helm/bin/helm /usr/local/bin
RUN ln -s /usr/local/bin/tiller /tiller

LABEL io.k8s.display-name="OpenShift metering-helm" \
      io.k8s.description="This is a base image used by operator-metering to assist in managing the lifecycle of the Openshift Metering components." \
      io.openshift.tags="openshift" \
      maintainer="Chance Zibolski <czibolsk@redhat.com>"
