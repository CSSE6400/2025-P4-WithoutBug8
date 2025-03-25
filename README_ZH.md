## 这是Practice-5的中文笔记

#### 本周重点内容
主要在讲Amazon云服务器EC2的配置与使用

#### 一些知识补充
1. EC2的初始化
   两种方法：
   - ①通过Amazon的图形化操作界面创建；

     - 什么是instance(实例)：EC2 Instance就是在AWS上租的一台云服务器，我可以在网站上直接进行操作，显然你可以创建很多个instances

       ![instance](/Users/bowen/Documents/Study/University of Queensland/CSSE6400 Software Architecture/Code/Task04/2025-P4-WithoutBug8/assets/instance.png)

     - 那么这个控制台是干什么的？Cloud Lab控制台是用于访问，操作创建的instance用，**注意：这个console reset以后再start需要花费很多的时间，有时甚至会花费一晚上，所以对于接下来的作业一定要提前上线，不要拖到最后一天再完成。千万要留意这个AWS Academy Assignment Learner Lab [112082]和AWS Academy Practicals Learner Lab [110995]**

       - AWS CLI是干什么的？首先CLI是命令行界面，也就是可以通过命令控制电脑或者云服务的一种方式，我的AWS CLI中内容如下

         ```bash
         access_key_id     # 你的账号
         secret_access_key # 密码
         session_token     # 临时访问的令牌，用于增强安全性
         ```

         

   - ②通过Terraform代码方式创建，一些具体的参数在这里说明一下
     - **AMI（Amazon Machine Image）**是系统镜像，决定虚拟机使用什么系统。
     
     - **Security Group** 安全组，相当于系统的防火墙，当你通过图形化界面创建instance的时候会自动配置好，不用太过操心，但是当你选择使用代码去实现的时候，必须显式的什么开放什么端口
     
       ```yaml
       resource "aws_security_group" "hextris-server" {
           name = "hextris-server"
           description = "Hextris HTTP and SSH access"
           # 这是入站端口80
           ingress {
               from_port = 80
               to_port = 80
               protocol = "tcp"
               cidr_blocks = ["0.0.0.0/0"]
           }
       		# 这是入站端口22
           ingress {
               from_port = 22
               to_port = 22
               protocol = "tcp"
               cidr_blocks = ["0.0.0.0/0"]
           }
       		# 这是出站端口，全部放行
           egress {
               from_port = 0   						# 起始端口0
               to_port = 0		  						# 终止端口0
               protocol = "-1" 						# 特殊协议-1，表示所以协议都匹配
               cidr_blocks = ["0.0.0.0/0"] # 允许所有IP访问
           }
       }
       ```
     
       在这里进行补充一下：**端口(port)**：是每一个自己的服务专属的号码。具体来说看上面的代码，22端口用于SSH连接，80端口用于访问网站应用

2. EC2的销毁

   - 和上面的创建一样有两种方法销毁EC2: ①通过Amazon的图形化操作界面销毁；②通过Terraform指令的方法销毁

     ```bash
     terraform init    # 初始化项目
     terraform plan    # 预演会发生什么，但是不会真的执行
     terraform destroy # 销毁创建的所有资源
     terraform apply   # 真正的执行变更，开始部署资源
     ```

     
