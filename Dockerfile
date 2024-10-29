# 使用 debian 基础镜像（带有 glibc）
FROM debian:latest

# 安装 wget 和 tar
RUN apt-get update && apt-get install -y wget tar && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 下载 x86_64 架构的 ENScan_GO 二进制文件
RUN wget -O enscan.tar.gz https://github.com/wgpsec/ENScan_GO/releases/download/v1.0.2/enscan-v1.0.2-linux-amd64.tar.gz && \
    tar -xzvf enscan.tar.gz && \
    mv enscan-v1.0.2-linux-amd64 enscan && \
    chmod +x enscan

# 暴露API端口
EXPOSE 31000

# 启动前先生成配置文件，然后启动API模式
CMD ./enscan -v && ./enscan --api
