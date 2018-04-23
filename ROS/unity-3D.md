![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/001.png)

# ROS# 安装和学习记录


ROS＃是C＃中的一组软件库和工具，用于.NET应用程序（尤其是Unity）与ROS进行通信
目的：实现ROS和unity 3D 的通信
参考译文网址：https://blog.csdn.net/zhangrelay/article/details/79008366
ROS#包括如下内容：
RosBridgeClient, a .NET API to ROS using rosbridge_suite on the ROS side.
UrdfImporter, a URDF file parser for .NET applications.
RosSharp.unitypackage, a Unity Asset package providing Unity-specific extensions to RosBridgeClient and UrdfImporter.
ROS#可以实现功能有
1. Communicate：通过Windows应用程序与ROS进行通讯（Linux不可以吗？）；订阅和发布主题，调用和发布服务，设置和获取参数以及使用rosbridge套件提供的所有功能。
2. Import：将机器人的URDF模型作为GameObject导入到Unity3D中。 使用robot_description服务直接从ROS系统导入数据，或通过复制到Unity资源文件夹中的URDF文件导入数据。
3. Control：通过Unity3D控制真实机器人。
4. Visualize：在Unity3D中可视化机器人的实际状态和传感器数据。
5. Simulate：使用URDF提供的数据在Unity3D中实现机器人仿真（这里不使用与ROS的连接的方式）。 除了网格和纹理的可视化组件之外，还可以导入了刚体的关节参数、质量、CoMs、惯性和碰撞等规格指标
6. And much more：更多功能！ROS＃可用于各种应用，如机器学习、人机交互、远程监控、虚拟原型、机器人操作、游戏和娱乐等！
参考github WIKI 网址：https://github.com/siemens/ros-sharp/wiki/Info_Showcases

ROS# 安装过程：
1.3 ROS on Ubuntu (ubuntu 16.04 已经安装)
再装一个rosbridge-suite 包
zypc@zypc-All-Series:~$ sudo apt-get install ros-kinetic-rosbridge-server
根据要求来：
Place the file_server package in the src folder of your catkin workspace
放置file_server到我的catkin_ws目录的src目录下
    Build by running $ catkin_make from the root folder of your catkin workspace
编译这个包
catkin_make -source src/file_server

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/002.png)


出现找不到PCL库的问题。PCL库 Point Cloud Library 点云的库。
...自行安装

```
sudo apt-get install libpcl1 libpcl1.7 libpcl-dev 
再编译。还是找不到
新建一个rossharp_ws 单独把包放到/home/zypc/rossharp_ws，编译通过
catkin_make -source src/file_server
zypc@zypc-All-Series:~/rossharp_ws$ catkin_make install
```

再安装到系统

```
zypc@zypc-All-Series:~/rossharp_ws$ source devel/setup.bash
```

索引环境变量

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/003.png)

启动节点成功
报错问题：xacro: Traditional processing is deprecated. Switch to --inorder processing!
解决办法：找到launch启动脚本，把语句

```
<param name="robot_description" command="$(find xacro)/xacro '$(find robot_description)/urdf/my_robot.urdf.xacro'" />
```
改为
```
<param name="robot_description" command="$(find xacro)/xacro '--inorder' '$(find robot_description)/urdf/my_robot.urdf.xacro'" />
```


开启新的标签页查看存在的服务（如下下图）
rosbridge-server 包位置在/opt/ros/kinetic/share/rosbridge_server
打开/opt/ros/kinetic/share/rosbridge_server/launch/rosbridge_websocket.launch
可以看到 launch 启动了 rosbridge_websocket节点，rosapi节点下的众多服务。
打开/opt/ros/kinetic/share/rosapi/srv 可以看到 rosapi 包下有多种类型的srv, 

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/004.png)
![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/005.png)

基本上能对应起来。
rosapi通过服务调用使某些ROS action可访问，包括获取和设置参数，获取主题列表等。rosbridge_library是核心rosbridge包。rosbridge_library负责获取JSON字符串并将命令发送到ros，反之亦然。rosbridge_server负责通信的传输层，包括websocket，tcp，udp等几种格式。

1.4 Gazebo Setup on VM (已经安装)

```
gazebo -version
```

```
Gazebo multi-robot simulator, version 7.0.0
Copyright (C) 2012-2016 Open Source Robotics Foundation.
Released under the Apache 2 License.
http://gazebosim.org


Gazebo multi-robot simulator, version 7.0.0
Copyright (C) 2012-2016 Open Source Robotics Foundation.
Released under the Apache 2 License.
http://gazebosim.org
```


1.5 TurtleBot2
在这个简单的场景中，.urdf作为robot_description的参数和robot/name parameter
参数需要发送到参数服务器，此外，rosbridge_websocket服务和file_server 在建立与Unity的连接中也是需要的。

```
sudo apt-get install ros-kinetic-turtlebot ros-kinetic-turtlebot-apps ros-kinetic-turtlebot-interactions ros-kinetic-turtlebot-simulator ros-kinetic-kobuki-ftd ros-kinetic-ar-track-alvar-msgs ros-kinetic-turtlebot-gazebo
```

除了无法定位软件包 ros-kinetic-kobuki-ftd 安装了ros-kinetic-kobuki-ftdi
其他安装没有问题
没有尝试运行 TurtleBot2 example

1.6 Shadow Hand（不是必须的）
这个例子解释了如何去建立一个阴影手模型，会在无ROS通信的例子里面用到。
下载工程源码：

```
git clone https://github.com/shadow-robot/simox_ros
```

正克隆到 'simox_ros'...
...
工程源码所在路径：/home/zypc/simox_ros
Shadow hand项目介绍 https://www.shadowrobot.com/products/dexterous-hand/
1.7ros-sharp包获取

```
git clone https://github.com/siemens/ros-sharp.git
```

正克隆到 'ros-sharp'...
工程源码路径：/home/zypc/ros-sharp


2. Application examples with ROS connection
下面有3个例子。导入URDF模型，Gazabo仿真，Unity仿真
2.1 Importing a URDF from ROS
在unity3D中导入URDF模型
 	  创建一个新的工程，工程的Assert下添加新资源RosShar。完成后可以看到菜单多了一个 RosBridgeClient 选项，点击显示-> import URDF Asserts 选项。再点击显示 -> 如下 RosSharp.Urdf 对话框。

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/006.png)

修改成本机IP

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/007.png)

连接状态改变

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/008.png)
  
  运行游戏

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/009.png)

Server端 终端打印信息，连接，直到断开？？


![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/010.png)


2.2 Gazebo Simulation Example 
    Gazebo 仿真实例，先不做
2.3 Unity Simulation Example
    Unity 仿真实例官方说明：
该图说明了在unity中实时仿真时，unity和ROS通信的原理

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/011.png)

正向-> 反向<- 都要通
概要说明：
控制信号从ROS传递到Unity, 因此，Unity的输出被ROS捕获并使用rviz加以证实。
使用ROS#被Unity订阅的消息：
/sensor_msgs/joy
Unity使用ROS#发布的Topic话题：
/odom，/joint_states，/unity_image/compressed

在Ubuntu系统中鼠标光标的移动用来控制Unity中的TurtelBot2，因此，ROS节点/mouse_to_joy.py把鼠标光标的移动映射到/sensor_msgs/joy类型的消息中。这些消息被发送到 rosbridge_websocket 然后被Unity捕获。
在Unity中，机器人会根据被捕获的鼠标光标运动来移动，同时，为了做进一步的处理，话题/odom，/joint_states，/unity_image/compressed 使用ROS#用来发布。

准备工作：
1、建立好Unity场景：链接URDF到ROS#
确保已经根据教程操作，操作者应该已经在Unity中导入了URDF模型
已经加载了 UnitySimulationScene.unity Unity场景，确保Unity场景已经加载完全可用
或者：根据视频介绍手动建立Unity场景，可以选择感兴趣的部分单个实现
2、建立ROS
确保根据教程操作
把unity_simulation_scene文件夹放到工作空间的src文件夹下，重新编译工作空间
在终端执行一下命令：
$ roslaunch unity_simulation_scene unity_simulation_scene.launch
该命令会同时启动rosbridge_websocket, file_server, mouse_to_joy 以及rqt_graph

执行：
一旦ROS节点启动，Unity中的机器人已经准备好移动了。
当点击“Play”按钮，Ubuntu中的鼠标光标移动，TurtleBot2 将会在Unity中移动
点击rqt_graph窗口的刷新按键，将会显示如下网络连接示意图

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/012.png)

实际使用记录：
导入 URDF模型，之前的方法是新建一个工程中在 Asserts文件夹下直接放值 RosSharp 文件包（来自git RosSharp工程源码），这里使用的方式是直接在Project右键直接导入untiy包UnitySimulationScene.unity（来自git RosSharp工程源码）

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/013.png)

zypc@zypc-All-Series:~/rossharp_ws$ roslaunch unity_simulation_scene unity_simulation_scene.launch
运行报错，找不到mouse_to_joy.py节点，错误代码如下：
can't locate node [mouse_to_joy.py] in package [unity_simulation_scene]
单独运行mouse_to_joy.py节点测试
zypc@zypc-All-Series:~/rossharp_ws$ rosrun unity_simulation_scene mouse_to_joy.py
运行报错，找不到Xlib库，错误代码如下：
from Xlib import display ImportError: No module named Xlib
手动安装python-xlib库

```
sudo apt install python-xlib
```

安装完毕之后运行launch。
如果还是报can't locate node [mouse_to_joy.py]的问题可能是因为mouse_to_joy.py本身的可执行权限问题。执行命令chmod a+x mouse_to_joy.py

点击run箭头运行unity3D 中的unity_simulation_scene场景，虽然很卡..但是一段时间后，运行起来了，鼠标移动UI没有任何反应，场景放大后如下图所示：

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/014.png)

unity_simulation_scene.launch终端获取鼠标箭头的坐标位置发生改变：

```
...
[INFO] [1523448326.618147]: header: 
  seq: 0
  stamp: 
    secs: 0
    nsecs:         0
  frame_id: ''
axes: [0.7518518518518519, 0.446875] //坐标信息[y, x]
buttons: []
...
```

以屏幕中心为坐标原点（0, 0）

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/015.png)

但实际通信方式情况如下图所示，没有/mouse_to_joy 和 /rosbridge_websocket 之间的 /joy topic. 不知道为什么ros端没有创建 /joy 这个节点，或者在这个节点上没有publish任何消息。

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/016.png)

不知道unity端的topic有没有建立 /odom，/joint_states，/unity_image/compressed 没有任何提示。

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/017.png)

在运行终端可以看到连接到指定端口后（192.168.56.101:9090 ？不是指定的192.168.1.33），出现了各种运行错误的打印，而且是基础的 Subscriber 和 Publisher.
rosSocket.Subscribe.cs 中，Line35:
rosSocket.Subscribe(xx,xx,xx,xx); 出现问题
rosSocket.Publisher.cs 中， line36:
publicationId = rosSocket.Advertise(Topic, MessageTypes.RosMessageType ( MessageProvider.MessageType ) ); 出现问题
具体什么问题不清楚。可能是IP引起的问题，可能是新老版本交替命名方式引起的问题。导致引用没有实例对象。


![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/018.png)


修改IP之后任然存在连接建立的问题。。。

//------------------------------------------------------------------------------------------------------
2018.4.21更新
RosSharp Git工程更新，修复导入的URDF模型名字为null的问题。修复方法，根据RosSharp 西门子官方提供的youtube 视频，修改RosConnector模型下， Urdf Patcher 脚本，Publish 和 Subscrib 对象的一些参数，修改了wheel_left/right_link的运动方向、速度等的脚本来源，速度，限制等参数（有些还不太明白起什么作用的参数）。


![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/019.png)

```
rostopic list
```

```
/joint_state
/joy
/odom
/rosout
/rosout_agg
/statistics
/unity_image/compressed
```

查看unity发布的某个topic 的接收情况，unity端的节点名称为/rosbridge_websocket

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/020.png)

附：unity3D rosConnecter 配置截图

![](http://7xku3c.com1.z0.glb.clouddn.com/ROS/021.png)
