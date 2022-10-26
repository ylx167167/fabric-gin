FROM golang:1.19 as builder

WORKDIR /go/src/github.com/flipped-aurora/gin-vue-admin/server
COPY . .

RUN go env -w GO111MODULE=on
RUN go env -w GOPROXY=https://goproxy.cn,direct
RUN go env -w CGO_ENABLED=0
RUN go env
RUN go mod tidy
RUN go build -o server .

FROM alpine:latest
LABEL MAINTAINER="SliverHorn@sliver_horn@qq.com"

WORKDIR /go/src/github.com/flipped-aurora/gin-vue-admin/server

COPY --from=0 /go/src/github.com/flipped-aurora/gin-vue-admin/server ./

EXPOSE 8888

ENTRYPOINT ./server -c config.docker.yaml


# FROM golang:1.19 as builder

# # WORKDIR /go/src/github.com/flipped-aurora/gin-vue-admin/server
# WORKDIR /wayneyao_server/
# COPY . .

# RUN go env -w GO111MODULE=on
# RUN go env -w GOPROXY=https://goproxy.cn,direct
# RUN go env -w CGO_ENABLED=0
# # RUN go env
# # RUN go mod tidy
# # RUN go build -o server .

# FROM alpine:latest
# LABEL MAINTAINER="417838124@qq.com"

# # WORKDIR /go/src/github.com/flipped-aurora/gin-vue-admin/server

# # COPY --from=0 /go/src/github.com/flipped-aurora/gin-vue-admin/server ./

# WORKDIR /wayneyao_server/

# EXPOSE 8888

# # ENTRYPOINT ./server -c config.docker.yaml
