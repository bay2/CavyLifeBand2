//
//  SignUpViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class SignUpViewController: UserSignInBaseViewController {

    // 手机输入框
    @IBOutlet weak var phoneTextField: SignInTextField!
    
    // 安全码输入框
    @IBOutlet weak var safetyCodeTextField: SignInTextField!
    
    // 密码输入框
    @IBOutlet weak var passwdTextField: SignInTextField!
    
    // 发送验证码按钮
    @IBOutlet weak var safetyCodeBtn: SendSafetyCodeButton!
    
    // 注册按钮
    @IBOutlet weak var signUpBtn: MainPageButton!
    
    // 用户协议框
    @IBOutlet weak var userProtocolView: UserProtocolView!
   
    // 输入框视图
    @IBOutlet weak var textFieldView: UIView!
    
    // 垂直分割线
    @IBOutlet weak var verticalLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateNavigationItemUI(L10n.SignUpTitle.string, rightBtnText: L10n.SignUpRightItemBtn.string)

        updateTextFieldViewUI(textFieldView)


        setSubViewsTitle()

        defineSubViewsLayout()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    /**
     设置title
     */
    func setSubViewsTitle() {

        phoneTextField.placeholder = L10n.SignUpPhoneNumTextField.string
        safetyCodeTextField.placeholder = L10n.SignUpSafetyCodeTextField.string
        passwdTextField.placeholder = L10n.SignInPasswdTextField.string

        signUpBtn.setTitle(L10n.SignUpSignUpBtn.string, forState: .Normal)
        safetyCodeBtn.setTitle(L10n.SignUpSendSafetyCode.string, forState: .Normal)
    }

    /**
     定义子视图布局
     */
    func defineSubViewsLayout() {

        defineViewLayout()

        defineButtonLayout()

        defineTextFieldLayout()

    }

    /**
     定义view 布局
     */
    func defineViewLayout() {

        textFieldView.snp_makeConstraints { (make) -> Void in
            
            make.top.equalTo(self.view).offset(spacingWidth25 * 8 - 64)
            make.left.equalTo(self.view).offset(spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(spacingWidth25 * 2))

            if (UIScreen.mainScreen().scale == 2) {         // tailor:disable
                make.height.equalTo((spacingWidth25 * 3) * 3 + 1)
            } else {
                make.height.equalTo((spacingWidth25 * 3) * 3 + 0.3)
            }

        }
        
        userProtocolView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(spacingWidth25 * 3)
            make.width.equalTo(280)
        }
        
        verticalLine.snp_makeConstraints { (make) -> Void in
            make.height.equalTo((spacingWidth25 * 3 / 5) * 3)
        }

    }

    /**
     定义按钮布局
     */
    func defineButtonLayout() {
        
        signUpBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textFieldView.snp_bottom).offset(spacingWidth25 * 3)
            make.left.equalTo(self.view).offset(spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(spacingWidth25 * 2))
            make.height.equalTo(spacingWidth25 * 3)
        }
        
        safetyCodeBtn.snp_makeConstraints { (make) -> Void in
            make.width.equalTo((spacingWidth25 * 3 / 5) * 9)
            make.right.equalTo(-spacingWidth25)
        }

    }

    /**
     定义输入框布局
     */
    func defineTextFieldLayout() {

        phoneTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textFieldView).offset(spacingWidth25)
            make.right.equalTo(textFieldView).offset(-spacingWidth25)
        }
        
        safetyCodeTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(phoneTextField)
        }
        
        passwdTextField.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(phoneTextField)
        }
        
    }
    

    /**
     点击发送验证码
     
     - parameter sender: 
     */
    @IBAction func onClickSafetyCode(sender: SendSafetyCodeButton) {
        
        sender.countDown()

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
