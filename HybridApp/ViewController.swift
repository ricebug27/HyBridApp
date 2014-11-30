//
//  ViewController.swift
//  HybridApp
//
//  Created by william on 14/11/30.
//  Copyright (c) 2014年 ricebug. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController,UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    let platformJs = "NativeBridge.js"
    let REQUEST_HEADER = "js-call:"
    var jsContent:NSString!//加了叹号表示一定不为空，？号表示可能为nil，如果不存在，则不继续执行
    var nativeCall:NativeCall!//本地调用的封装类
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appInit()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appInit(){
        self.webView.delegate = self
        //初始化本地调用类
        self.nativeCall = NativeCall(webView: self.webView)
        //指定加载本地HTML的路径
        var url =  NSBundle.mainBundle().pathForResource("index", ofType: "html",inDirectory:"html")
        var urlRequest = NSURLRequest(URL :NSURL.fileURLWithPath(url!)!)
        //读取注入js的URL
        var jsUrl = NSBundle.mainBundle().pathForResource(platformJs, ofType: nil)
        //读取注入js的内容
        jsContent = NSString(contentsOfFile: jsUrl!, encoding:NSUTF8StringEncoding, error:nil)
        self.view.addSubview(webView)
        webView.loadRequest(urlRequest)
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        webView.stringByEvaluatingJavaScriptFromString(jsContent)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var url = request.URL.absoluteString?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        if(url!.hasPrefix(REQUEST_HEADER)){
            println(url)
            var postparm:NSString = url!.substringFromIndex(advance(url!.startIndex, 8))
            nativeCall.processCmd(postparm)
            return false

        }
        return true
    }

}

