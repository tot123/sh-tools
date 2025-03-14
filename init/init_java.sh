#!/bin/bash
mkdir -p ~/env

# 安装 JDK 8
wget -O jdk-8.tar.gz https://github.com/adoptium/temurin8-binaries/releases/download/jdk8u402-b06/OpenJDK8U-jdk_x64_linux_hotspot_8u402b06.tar.gz
mkdir -p ~/env/jdk8 && tar zxf jdk-8.tar.gz -C ~/env/jdk8 --strip-components=1

# 安装 JDK 11
wget -O jdk-11.tar.gz https://github.com/adoptium/temurin11-binaries/releases/download/jdk-11.0.20.1%2B1/OpenJDK11U-jdk_x64_linux_hotspot_11.0.20.1_1.tar.gz
mkdir -p ~/env/jdk11 && tar zxf jdk-11.tar.gz -C ~/env/jdk11 --strip-components=1

# 安装 JDK 17
wget -O jdk-17.tar.gz https://download.java.net/java/GA/jdk17.0.2/dfd4a8d0985749f896bed50d7138ee7f/8/GPL/openjdk-17.0.2_linux-x64_bin.tar.gz
mkdir -p ~/env/jdk17 && tar zxf jdk-17.tar.gz -C ~/env/jdk17 --strip-components=1

# 安装 JDK 21（示例已存在，但为完整起见保留）
wget -O jdk-21.tar.gz https://download.java.net/java/GA/jdk21.0.2/f2283984656d49d69e91c558476027ac/13/GPL/openjdk-21.0.2_linux-x64_bin.tar.gz
mkdir -p ~/env/jdk21 && tar zxf jdk-21.tar.gz -C ~/env/jdk21 --strip-components=1

# 配置环境变量（追加到 ~/.bashrc 或 ~/.zshrc）
cat << 'EOF' >> ~/.bashrc
export ENV_DIR="$HOME/env"

export JAVA_HOME8="$ENV_DIR/jdk8"
export JAVA_HOME11="$ENV_DIR/jdk11"
export JAVA_HOME17="$ENV_DIR/jdk17"
export JAVA_HOME21="$ENV_DIR/jdk21"

export JAVA_HOME="$JAVA_HOME17"
export PATH="$JAVA_HOME/bin:$PATH"
EOF

# 立即生效配置
source ~/.bashrc

# 验证默认Java版本
echo $JAVA_HOME     # 应显示与JAVA_HOME17相同的路径
java -version       # 应输出JDK 17的版本信息

# 验证变量是否存在（正确输出应显示各版本JDK路径）
echo $JAVA_HOME8
echo $JAVA_HOME11
echo $JAVA_HOME17
echo $JAVA_HOME21