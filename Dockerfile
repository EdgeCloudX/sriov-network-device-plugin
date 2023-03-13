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