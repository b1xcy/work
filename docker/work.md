## level1：

![image-20221127230830896](https://cdn.jsdelivr.net/gh/b1xcy/img/202211272308997.png)

## level2：

#### 构建镜像

![image-20221127232533705](https://cdn.jsdelivr.net/gh/b1xcy/img/202211272325727.png)

![image-20221127232544543](https://cdn.jsdelivr.net/gh/b1xcy/img/202211272325565.png)

![image-20221127233256632](https://cdn.jsdelivr.net/gh/b1xcy/img/202211272332659.png)

![image-20221127233548793](https://cdn.jsdelivr.net/gh/b1xcy/img/202211272335817.png)

#### 上传到dockerhub

![image-20221128002502625](https://cdn.jsdelivr.net/gh/b1xcy/img/202211280025661.png)

地址为：[Image Layer Details - b1xcy/nginx_test:new | Docker Hub](https://hub.docker.com/layers/b1xcy/nginx_test/new/images/sha256-660f302e47ed2d61e408fdfb214db342193e27cc46dc16c7eff7b90510dcfa84?context=repo)

#### 本地显示：

![image-20221128002626317](https://cdn.jsdelivr.net/gh/b1xcy/img/202211280026347.png)

## level3：

先构建docker-compose.yml文件，如下：

```yaml
version: "3"
services: 
  nginx: 
    image: nginx
    container_name: nginx
    volumes: 
    - ./sh:/sh
    ports: 
    - "80:80"
    privileged: true
    entrypoint: [ "/sh/ping.sh" ]
    
  nginx_new:
    image: b1xcy/nginx_test:new
    container_name: b1xcy
    ports:
    - "8080:80"
    volumes: 
    - ./sh:/sh
    privileged: true

```

其中，ping.sh文件是用于在nginx容器内部的换源，升级，安装ping和ping b1xcy容器的shell脚本，如下

```shell
#!/bin/bash
cp /etc/apt/sources.list /etc/apt/sources.list.bak
echo 'deb http://mirrors.163.com/debian/ stretch main non-free contrib' > /etc/apt/sources.list
echo 'deb http://mirrors.163.com/debian/ stretch-updates main non-free contrib' >> /etc/apt/sources.list
echo 'deb http://mirrors.163.com/debian-security/ stretch/updates main non-free contrib' >> /etc/apt/sources.list
apt-get -y upgrade
apt-get -y update
apt-get -y install iputils-ping 
touch /sh/test 
ping -c 10 b1xcy > /sh/test
tail -f /dev/null	#加此行命令是为了保证容器不自动关闭，因为当docker检测到没有前台任务要执行后，会退出container。我也不理解为什么nginx本身的服务不算做“前台任务”
```

将./sh文件挂载到nginx容器内的/sh目录，然后在将ping的结果输出到/sh/test文件中，由于挂载的存在，所以在外部也可以看到ping的结果

完成后运行docker-compose up

结果如下：

![image-20221130175902273](https://cdn.jsdelivr.net/gh/b1xcy/img/202211301802659.png)

使用的镜像一个是nginx官方镜像，一个是自己构建的改版nginx镜像，地址为[Image Layer Details - b1xcy/nginx_test:new | Docker Hub](https://hub.docker.com/layers/b1xcy/nginx_test/new/images/sha256-660f302e47ed2d61e408fdfb214db342193e27cc46dc16c7eff7b90510dcfa84?context=repo)
