//
//  NativeCall.swift
//  WebApp
//  本地化调用类。
//  这个类可以实现JavaScript调用例如通知，声音，振动，GPS定位，相机，相册，电话本等设备本地应用
//  Created by william on 14-8-2.
//  Copyright (c) 2014年 william. All rights reserved.
//

import UIKit


class NativeCall{
    
    var webView:UIWebView!
    
    init(webView:UIWebView){
        self.webView = webView
    }
    
    /**
    **  处理调用指令
    **/
    func processCmd(cmd:String){
        var parm = cmd.componentsSeparatedByString(":")
        var function = parm[0]
        var callbackId = parm[1]
        var argsString = parm[2]
        if("notify"==function){
            callMsg(argsString)
        }else if("getData"==function){
            var resultJson = "{\"person\":{\"name\":\"飙猪狂\",\"age\":\"18\",\"info\":"+argsString+"}}"
            resultForCallback(callbackId,resultJson: resultJson);
        }
    }
    
    /**
    ** 这个是JavaScript调用NativeCall的回调函数，用来返回结果给JavaScript。
    **
    **/
    func resultForCallback(callbackId:String,resultJson:String){
        webView.stringByEvaluatingJavaScriptFromString("NativeBridge.resultForCallback("+callbackId+",['"+resultJson+"']);")
    }
    
    func callMsg(msg:String){
        var localNotification = UILocalNotification()
        localNotification.alertAction = "这是来自飙猪狂应用的通知"
        localNotification.alertBody = msg
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
    }
    
}