# 使用 x86_64 版本的基础镜像
FROM alpine:latest

# 安装 wget、tar 和 ca-certificates
RUN apk add --no-cache wget ca-certificates tar

# 设置工作目录
WORKDIR /app

# 下载 x86_64 架构的 ENScan_GO 二进制文件
RUN wget -O enscan.tar.gz https://github.com/wgpsec/ENScan_GO/releases/download/v1.0.2/enscan-v1.0.2-linux-amd64.tar.gz && \
    tar -xzvf enscan.tar.gz && \
    mv enscan-v1.0.2-linux-amd64 enscan && \
    chmod +x enscan

# 暴露API端口
EXPOSE 8080

# 启动API模式
CMD ["./enscan", "--api"]
