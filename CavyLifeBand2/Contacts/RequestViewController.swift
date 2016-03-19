//
//  VerifyViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MHRotaryKnob
import Log

class RequestViewController: UIViewController {

    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)

        requestViewLayout()
        
        
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backAction(sender: AnyObject) {
        self.popVC()
    }
    
    @IBAction func sendRequest(sender: AnyObject) {
        
        Log.info("发送好友请求\(requestTextField.text)")
    }
    
    func requestViewLayout() {
        
        requestTextField.placeholder = L10n.ContactsRequestPlaceHolder.string
        
        sendButton.setTitle(L10n.ContactsRequestSendButton.string, forState: .Normal)
        sendButton.setTitleColor(UIColor(named: .MainPageBtnText), forState: .Normal)
        sendButton.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(requestTextField).offset(requestTextField.frame.height)
            
        }
        
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
