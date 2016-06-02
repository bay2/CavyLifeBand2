//
//  WebViewController.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/6.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, BaseViewControllerPresenter {
    
    var webView: UIWebView = UIWebView()
    
    var dataSource: WebVCDataSourceProtocol?
    
    var navTitle: String { return dataSource?.navTitle ?? "" }
    
    var navRightBtnTitle: String { return dataSource?.navRightBtnTitle ?? ""}
    
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    lazy var rightBtn: UIButton? =  {
        
        if self.navRightBtnTitle == "" {
            return nil
        }
        
        let titleSize = self.navRightBtnTitle.boundingRectWithSize(CGSizeMake(100, 20), options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.mediumSystemFontOfSize(14.0)], context: nil)
        
        let button = UIButton(type: .System)
        
        button.frame = CGRectMake(0, 0, titleSize.width, 30)
        button.setTitle(self.navRightBtnTitle, forState: .Normal)
        button.titleLabel?.font = UIFont.mediumSystemFontOfSize(14.0)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        return button
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = .None
        self.navigationController?.navigationBar.translucent = false
        
        updateNavUI()
        
        addWebView()
        
        addLodingView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func loadView() {
        
        self.view = UIView()
        self.view.backgroundColor = UIColor.whiteColor()
        
    }
    
    //添加webview
    func addWebView() {
        
        self.view.addSubview(webView)
        
        webView.snp_makeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        
        webView.delegate = self
        
        let webUrl = NSURL.init(string: dataSource?.webUrlStr ?? "")
        let webRequeat = NSURLRequest.init(URL: webUrl!)
        
        webView.loadRequest(webRequeat)
        
    }
    
    //添加转圈圈提示view
    func addLodingView() {
        
        self.view.addSubview(loadingView)
        
        loadingView.hidesWhenStopped = true
        
        loadingView.activityIndicatorViewStyle = .Gray
        
        loadingView.snp_makeConstraints { make in
            make.center.equalTo(self.view)
            make.width.equalTo(50.0)
            make.height.equalTo(50.0)
        }
        
    }
    
    func onRightBtn() {
        
        dataSource?.navRightBtnAction()
        
    }
    
    deinit {
        
        Log.info("deinit")
        
    }

}

// MARK: - UIWebViewDelegate
extension WebViewController: UIWebViewDelegate {
    
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        loadingView.stopAnimating()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        loadingView.stopAnimating()
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        loadingView.startAnimating()
    }
    
}

typealias navBtnHandle = () -> Void

protocol WebVCDataSourceProtocol {
    
    var navTitle: String { get }
    
    var navRightBtnTitle: String { get }
    
    var webUrlStr: String { get }
    
    var navRightBtnAction: navBtnHandle { get }
    
}

extension WebVCDataSourceProtocol {

    var navTitle: String { return "" }
    
    var navRightBtnTitle: String { return "" }
    
    var navRightBtnAction: navBtnHandle { return {} }

}


