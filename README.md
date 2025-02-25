# Expense-manage

一个便捷的团体开支管理程序，支持多人协作，计算最优的支付方案。

## 使用场景

- 一群人出游，记录每个人支付过的费用，最后计算每个人应该支付多少钱给其他人。

## 使用方法

### 0.环境要求

已安装 Docker Compose

### 1. 克隆项目或下载必要文件

首先，从 GitHub 仓库下载 `.example.env` 文件、`docker-compose.yml` 文件和 `nginx.conf` 文件。

```sh
wget https://github.com/SideCloudGroup/Expense-manage/raw/refs/heads/main/.example.env -O .env
wget https://github.com/SideCloudGroup/Expense-manage/raw/refs/heads/main/docker-compose.yml
wget https://github.com/SideCloudGroup/Expense-manage/raw/refs/heads/main/nginx.conf
```

### 2. 配置环境变量

根据项目需求修改 `.env` 文件中的变量，例如数据库连接信息、端口配置等。

### 3. 启动 Docker Compose

在 `.env` 文件配置完成后，执行以下命令启动 Docker Compose：

```sh
docker compose up -d
```

该命令将在后台启动所有定义的容器。

### 4. 配置反向代理

您可以使用 Nginx 或 Cloudflare Tunnel 等工具配置反向代理，将服务暴露到公网。

### 5. 验证服务是否运行

检查容器状态：

```sh
docker compose ps
```

检查日志输出：

```sh
docker compose logs -f
```

如果一切正常，你的服务应该已经成功运行，并通过反向代理访问。

### 后续操作

前往`/admin`可添加用户。所有用户均可发起收款。收款发起人可以修改收款项目的状态。

在管理面板内可查询`计算最优待支付`，用于在最后阶段计算优化后的支付方案。