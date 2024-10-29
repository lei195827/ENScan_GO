# 使用基础镜像
FROM alpine:latest 

# 安装wget和ca-certificates，确保可以下载文件
RUN apk add --no-cache wget ca-certificates tar

# 设置工作目录
WORKDIR /app

# 下载并解压ENScan_GO的二进制文件
RUN wget -O enscan.tar.gz https://github.com/wgpsec/ENScan_GO/releases/download/v1.0.2/enscan-v1.0.2-linux-arm64.tar.gz && \
    tar -xzvf enscan.tar.gz && \
    chmod +x enscan

# 暴露API端口
EXPOSE 8080

# 启动API模式
CMD ["./enscan", "--api"]
