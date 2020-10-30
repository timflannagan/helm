FROM openshift/origin-release:golang-1.15 as build

RUN yum install --setopt=skip_missing_names_on_install=False -y \
        hg git make \
    && yum clean all \
    && rm -rf /var/cache/yum

ENV GOPATH /go
RUN mkdir -p /go/src/k8s.io/helm

WORKDIR /go/src/k8s.io/helm
COPY . .

# unset VERSION inherited from base before building
ENV VERSION ""
RUN make build

FROM centos:7

COPY --from=build /go/src/k8s.io/helm/bin/helm /usr/local/bin

LABEL io.k8s.display-name="OpenShift metering-helm" \
      io.k8s.description="This is a base image used by operator-metering to assist in managing the lifecycle of the Openshift Metering components." \
      io.openshift.tags="openshift" \
      maintainer="<metering-team@redhat.com>"
