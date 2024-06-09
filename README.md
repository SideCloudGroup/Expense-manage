# Expense-manage
一个便捷的团体开支管理程序，支持多人协作，计算最优的支付方案。

## 使用场景
- 一群人出游，记录每个人支付过的费用，最后计算每个人应该支付多少钱给其他人。

## 使用方法

### 0.环境要求
PHP>=8.0, MySQL或MariaDB

### 1.下载源码
略

### 2.修改配置文件
将配置文件`.example.env`复制一份，名字改为`.env`，并填写设置项。

### 3.安装依赖
安装前请确保已启用`putenv`和`proc_open`函数，并安装`fileinfo`拓展。
```bash
wget https://getcomposer.org/installer -O composer.phar
php composer.phar
php composer.phar install
```

### 4.导入数据库
```bash
php think migrate:run
```

### 5.设置伪静态和运行目录
设置网站运行目录为`/public`

设置伪静态为
```nginx
location ~* (runtime|application)/{    
    return 403;
}
location / {
    if (!-e $request_filename){
        rewrite  ^(.*)$  /index.php?s=$1  last;   break;
    }
}
```

### 6.设置权限
将整个网站目录权限设置为755，所有者为www（或其他对应的用户）

### 后续操作
前往`/admin`可添加用户。所有用户均可发起收款。收款发起人可以修改收款项目的状态。

在管理面板内可查询`计算最优待支付`，用于在最后阶段计算优化后的支付方案。