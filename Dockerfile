# 使用golang基础镜像
FROM golang:1.19 AS build-stage

# 克隆 ENScan_GO 项目
RUN git clone --depth 1 https://github.com/wgpsec/ENScan_GO.git

WORKDIR /ENScan_GO

# 配置环境变量和代理
ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,direct

# 编译 ENScan_GO，启用API模式
RUN CGO_ENABLED=0 go build -trimpath -ldflags=" \
    -w -s \
    -X 'github.com/wgpsec/ENScan/common.BuiltAt=`date +'%F %T %z'`' \
    -X 'github.com/wgpsec/ENScan/common.GoVersion=`go version | sed 's/go version //'`' \
    -X 'github.com/wgpsec/ENScan/common.GitAuthor=`git show -s --format='format:%aN <%ae>' HEAD`' \
    -X 'github.com/wgpsec/ENScan/common.GitCommit=`git log --pretty=format:"%h" -1`' \
    -X 'github.com/wgpsec/ENScan/common.GitTag=`git describe --abbrev=0 --tags`' \
" \
-o /enscan .

# 使用轻量级镜像进行部署
FROM scratch
WORKDIR /
COPY --from=build-stage /enscan /enscan

# 设置 API 启动命令
ENTRYPOINT ["/enscan", "--api"]
