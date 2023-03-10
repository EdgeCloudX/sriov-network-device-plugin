# # Build Stage
# FROM golang:1.18.6

# LABEL APP="k8snetworkplumbingwg/sriov-network-device-plugin"
# LABEL REPO="harbor-dev.eecos.cn:1443/ecf-edge/k8snetworkplumbingwg/sriov-network-device-plugin"
# ENV TZ Asia/Shanghai

# CMD ["/bin/sh"]
# ADD . /go/src/EdgeCloudX/sriov-network-device-plugin
# WORKDIR /go/src/EdgeCloudX/sriov-network-device-plugin
# RUN go env -w GOOS=linux GOPROXY=https://goproxy.io,direct GO111MODULE=on
# RUN go env
# RUN ["/bin/sh","-c","make"]
# RUN /go/src/EdgeCloudX/sriov-network-device-plugin/sriovdp


# FROM golang:1.18-alpine as builder
# LABEL APP="sriov-network-device-plugin"
# LABEL REPO="ecf-edge/k8snetworkplumbingwg/sriov-network-device-plugin"
# ADD . /go/src/EdgeCloudX/sriov-network-device-plugin

# WORKDIR /go/src/EdgeCloudX/sriov-network-device-plugin
# RUN apk add --no-cache --virtual build-dependencies build-base linux-headers make git && make build

# FROM alpine:3.17.2
# LABEL io.k8s.display-name="SRIOV Network Device Plugin"
# RUN apk add --no-cache hwdata-pci
# COPY --from=builder /go/src/EdgeCloudX/sriov-network-device-plugin/build/sriovdp /usr/bin/
# WORKDIR /go/src/EdgeCloudX/sriov-network-device-plugin
# COPY ./images/entrypoint.sh /

# RUN rm -rf /var/cache/apk/*

# ENTRYPOINT ["/entrypoint.sh"]

FROM golang:1.18-alpine AS builder
LABEL APP="sriov-network-device-plugin"
LABEL REPO="EdgeCloudX/sriov-network-device-plugin"
LABEL io.k8s.display-name="SRIOV Network Device Plugin"
ADD . /go/src/EdgeCloudX/sriov-network-device-plugin
WORKDIR /go/src/EdgeCloudX/sriov-network-device-plugin
RUN apk add --no-cache make && make build

FROM alpine:3
COPY --from=builder /go/src/EdgeCloudX/sriov-network-device-plugin/build/sriovdp /usr/bin/sriovdp
COPY --from=builder /go/src/EdgeCloudX/sriov-network-device-plugin/images/entrypoint.sh /
RUN rm -rf /go/src/EdgeCloudX/*

ENTRYPOINT ["/entrypoint.sh"]