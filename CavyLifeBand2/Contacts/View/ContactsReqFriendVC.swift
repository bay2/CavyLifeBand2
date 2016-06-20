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

class ContactsReqFriendVC: UIViewController, BaseViewControllerPresenter {

    enum RequestStyle {
        
        case AddFriend
        case ChangeNotesName
        case ChangeSelfName
        
    }

    var viewModel: ContactsReqFriendPortocols?
    
    @IBOutlet weak var textFieldView: UIView!
    
    /// TextField
    @IBOutlet weak var requestTextField: UITextField!
    
    /// Button
    @IBOutlet weak var sendButton: MainPageButton!
    
    var requestStyle: RequestStyle = .AddFriend
    
    var navTitle: String {
        
        return viewModel?.navTitle ?? ""
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        updateNavUI()

        requestViewLayout()
        
    }
    

    /**
     点击发送按钮
     
     - parameter sender:
     */
    @IBAction func sendRequest(sender: AnyObject) {
        
        viewModel?.textFieldTitle = requestTextField.text ?? ""
        viewModel?.onClickButton()
        
    }
    
    
    
    /**
     配置视图
     
     - parameter dataSource:
     */
    func viewConfig(model: ContactsReqFriendPortocols) {
        
        self.viewModel = model
        
    }
    
    /**
     布局
     */
    func requestViewLayout() {
        
        textFieldView.layer.cornerRadius = CavyDefine.commonCornerRadius
        sendButton.layer.masksToBounds = true
        sendButton.layer.cornerRadius = 3
        
        sendButton.setTitle(viewModel?.bottonTitle, forState: .Normal)
        
        requestTextField.placeholder = viewModel?.placeholderText
        requestTextField.text = viewModel?.textFieldTitle
        requestTextField.textColor = UIColor(named: .TextFieldTextColor)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
