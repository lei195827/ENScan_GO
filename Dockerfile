# 使用 golang 基础镜像
FROM golang:1.19 AS build-stage

# 克隆 ENScan_GO 项目
RUN git clone --depth 1 https://github.com/wgpsec/ENScan_GO.git

WORKDIR /ENScan_GO

# 设置默认构建参数
ARG BUILD_AT="Unknown Build Time"
ARG GO_VERSION="Unknown Go Version"
ARG GIT_AUTHOR="Unknown Author"
ARG GIT_COMMIT="Unknown Commit"
ARG GIT_TAG="Unknown Tag"

# 配置Go环境
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

# 编译 ENScan_GO 程序，使用提供的构建参数
RUN CGO_ENABLED=0 go build -trimpath -ldflags=" \
    -w -s \
    -X 'github.com/wgpsec/ENScan/common.BuiltAt=${BUILD_AT}' \
    -X 'github.com/wgpsec/ENScan/common.GoVersion=${GO_VERSION}' \
    -X 'github.com/wgpsec/ENScan/common.GitAuthor=${GIT_AUTHOR}' \
    -X 'github.com/wgpsec/ENScan/common.GitCommit=${GIT_COMMIT}' \
    -X 'github.com/wgpsec/ENScan/common.GitTag=${GIT_TAG}'" \
    -o /enscan .

# 使用轻量级镜像进行部署
FROM scratch
WORKDIR /
COPY --from=build-stage /enscan /enscan

# 设置 API 启动命令
ENTRYPOINT ["/enscan", "--api"]
