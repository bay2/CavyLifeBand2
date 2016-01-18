//
//  Weather.swift
//  CavyLifeBand2
//
//  Created by 李艳楠 on 16/1/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class Weather: UIViewController {

    
    var url = "http://apis.baidu.com/heweather/weather/free"
    //var httpArg = "city=hangzhou"
    var httpArg = "cityid=CN101210101"
    
    func  request(httpUrl: String, httpArg: String) {
        let req = NSMutableURLRequest(URL: NSURL(string: httpUrl + "?" + httpArg)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("9ffe366d2c88961f9bd8e06071b31bc5", forHTTPHeaderField: "apikey")
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in
//            let res = response as! NSHTTPURLResponse!
//            print("res.statusCode:\(res.statusCode)")
//            if error != nil {
//                print("请求失败")
//            }
//            if let d = data {
//                // 解析数据
//                let content = NSString(data: d, encoding: NSUTF8StringEncoding)
//                print(content)
//                
            
                
                
                
                
                
                
                
//            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        request(url, httpArg: httpArg)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
