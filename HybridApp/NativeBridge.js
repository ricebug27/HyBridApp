var NativeBridge = {
    callbacksCount : 1,
    callbacks : {},
    
    //定义了自动回调函数
    resultForCallback : function resultForCallback(callbackId, resultJson) {
        try {
            var callback = NativeBridge.callbacks[callbackId];
            if (!callback) return;
            var obj = [resultJson];
            callback.apply(null,obj);
        } catch(e) {alert(e)}
    },
    
    // Use this in javascript to request native objective-c code
    // functionName : string
    // args : array of arguments
    // callback : function with n-arguments that is going to be called when the native code returned
    call : function call(functionName, args, callback) {

        var hasCallback = callback && typeof callback == "function";
        var callbackId = hasCallback ? NativeBridge.callbacksCount++ : 0;
        if (hasCallback)
            NativeBridge.callbacks[callbackId] = callback;
        //使用Iframe来处理是因为在一个页面里，JavaScript是单线程的，为了避免对应用页面的执行性能进行干扰，临时创建一个IFrame来进行本地调用的运算。
        var iframe = document.createElement("IFRAME");
        //JSON是ECMAscript5提供的全局对象。IE8及以上的版本支持此对象，但需要注意的是，在这些高版本的浏览器上有的页面可能使用兼容视图加载，这时就可能不支持此对象了
        iframe.setAttribute("src", "js-call:" +escape(functionName + ":" + callbackId+ ":" + encodeURIComponent(JSON.stringify(args))));
        //兼容IOS6模拟器，创建一个1px大小的Iframe
        iframe.setAttribute("height", "1px");
        iframe.setAttribute("width", "1px");
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
    }
    
};