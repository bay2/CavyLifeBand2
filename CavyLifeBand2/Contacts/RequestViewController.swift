//
//  VerifyViewController.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/3/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import MHRotaryKnob

class RequestViewController: UIViewController {

    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        verifyViewLayout()
        
        
        
        // Do any additional setup after loading the view.
    }

    func verifyViewLayout() {
        
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
