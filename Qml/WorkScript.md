# WorkScript

1. qml 执行js，会另外开启新线程，使用sendMessage／onMessage传递消息。
  若需要开启线程执行耗时操作，可以使用workscript。

2. InfluxDB 的batch 保存数据，可以减少Http请求次数。

3. Http 1.1 默认使用长连接，多次请求会复用http连接。

__`main.qml`:__

```
import QtQuick 2.0
  
Rectangle {
    width: 300; height: 300
  
    Text {  
        id: myText  
        text: 'Click anywhere'  
    }  
  
    WorkerScript {  
        id: myWorker  
        source: "script.js"  
  
        onMessage: myText.text = messageObject.reply  
    }  
  
    MouseArea {
        anchors.fill: parent
        onClicked: {
        	for(var i = 1; i<= 200; i++)
                myWorker.sendMessage({ 'x':  mouse.x, 'y': mouse.y, 'th': i })
            }
        onDoubleClicked: myText.text = myText.text + "dbl click.."
    }  
}
```

__`script.js`:__


```
WorkerScript.onMessage = function(message) {
    console.log("hello");
    var text = getText("http://localhost:8080/a");
    console.log(text);
    WorkerScript.sendMessage({ 'reply': 'th: ' + message.th + ' Mouse is at ' + message.x + ',' + message.y+"\n"+text })
}

function getText( url ){
    var request = new XMLHttpRequest();
    request.timeout = 1000;
    request.responseType = "text";
    // HTTP 1.1 默认使用长连接
    request.connection = "keep-alive";
    // request.connection = "close";
    // 异步方式，页面接受不到该改回值
    request.open( "GET", url , true); 
    request.onreadystatechange = function(){
        if( request.readyState !== 4 ) return 'not4';
        if( request.status === 200 ){
            return request.responseText;
        }else{
            return "not200"
        }
    }
    //注册相关事件回调处理函数
//      request.onload = function(e) {
//        if(this.status == 200||this.status == 304){
//            console.log(this.responseText);
//        }
//      };
    request.send( url );

    return request.responseText;
}
```