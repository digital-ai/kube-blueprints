#
# used to run kuttl tests from docker
# it is expected that a mount pt is provided where /opt/project is the root of the testsuite
# the root of the mount point needs a `kuttl-test.yaml` and a proper `kubeconfig` file which
# a process running in docker can reach.  If using kind, then `kind get kubeconfig --internal > kubeconfig`
# will provide the proper configuration for 0.7.0.  0.8.0 breaks this ability and is being worked on in the
# kind community.
# Assuming a test folders at mount root named "e2e" then:
# docker run -v $PWD:/opt/project kuttl e2e
# will run tests against the e2e folders.
#
# IF you want run tests from within a cluster, then specify `-e KUBECONFIG=`.  An empty KUBECONFIG will
# result in kuttl using the in-cluster-config.
# ex. docker run -e KUBECONFIG= -v $PWD:/opt/project kuttl e2e
# artifacts by default will land in the root of the mount point.

# to build copy file to kuttl src dir and run
# git clone https://github.com/kudobuilder/kuttl.git
# cd kuttl
# cp digitalai/kube-blueprints/tests/e2e/docker/Dockerfile .
# docker build .
# docker tag e42dec0b9174 xldevdocker/kuttl:latest

# kuttl builder
FROM golang:1.22 as builder

WORKDIR /go/src/kuttl
COPY . .

RUN go get -d -v ./...
RUN make cli

# release image with kubectl + kuttl
FROM registry.access.redhat.com/ubi9/openjdk-17:latest
LABEL org.opencontainers.image.source="https://github.com/kudobuilder/kuttl"

USER root

RUN microdnf install -y glibc vim tar gzip git
RUN echo 'alias vi=vim' >> ~/.bashrc

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

RUN curl -LO https://github.com/mikefarah/yq/releases/download/v4.44.3/yq_linux_amd64 \
    && chmod +x yq_linux_amd64 \
    && mv yq_linux_amd64 /usr/local/bin/yq

RUN curl https://get.helm.sh/helm-v3.17.1-linux-amd64.tar.gz |\
    tar xz && mv linux-amd64/helm /usr/local/bin/helm

RUN helm plugin install https://github.com/nikhilsbhat/helm-images

COPY --from=builder /go/src/kuttl/bin/kubectl-kuttl /usr/bin/kubectl-kuttl

RUN mkdir -p /opt/project
RUN chown 1001 /opt/project

USER 1001

WORKDIR /opt/project

# default configuration
ENV KUBECONFIG=kubeconfig

# standard kuttl test in entry point, flags and test folder can be provided as CMD
ENTRYPOINT ["kubectl", "kuttl", "test"]
