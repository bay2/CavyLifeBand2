//
//  SignInViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/25.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import SnapKit
import EZSwiftExtensions
import Log

class SignInViewController: AccountManagerBaseViewController, SignInDelegate {

    // 登入按钮
    @IBOutlet weak var signInBtn: MainPageButton!

    // 输入框视图
    @IBOutlet weak var textFieldView: UIView!

    // 密码输入框
    @IBOutlet weak var passwdTextField: AccountTextField!

    // 用户名输入框
    @IBOutlet weak var userNameTextField: AccountTextField!

    // 忘记密码按钮
    @IBOutlet weak var forgetPasswdBtn: UIButton!
    
    var userName: String {
        return userNameTextField.text!
    }
    
    var passwd: String {
        return passwdTextField.text!
    }
    
    var viewController: UIViewController? {
        return self
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
        

        updateTextFieldViewUI(textFieldView)

        updateNavigationItemUI(L10n.SignInTitle.string, rightBtnText: L10n.SignInSignUpItemBtn.string)

        // 定义视图布局
        defineSubViewLayer()
        
        // 设置控件title
        setSubViewTitle()
        
        userNameTextField.becomeFirstResponder()
        userNameTextField.backgroundColor = UIColor.whiteColor()
        passwdTextField.backgroundColor = UIColor.whiteColor()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     设置子视图标题
     */
    func setSubViewTitle() {
        
        userNameTextField.placeholder = L10n.SignInUserNameTextField.string
        passwdTextField.placeholder = L10n.SignInPasswdTextField.string
        
        forgetPasswdBtn.titleLabel?.text = L10n.SignInForgotPasswdBtn.string
        forgetPasswdBtn.setTitleColor(UIColor(named: .SignInForgotPwdBtnText), forState: .Normal)
        
        signInBtn.titleLabel?.text = L10n.SignInPasswdTextField.string
        
    }
    
    /**
     定义子视图布局
     */
    func defineSubViewLayer() {
        
        defineViewLayer()
        defineTextFieldLayer()
        defineButtonLayer()
        
    }
    
    /**
     定义视图布局
     */
    func defineViewLayer() {
        
        textFieldView.snp_makeConstraints { (make) -> Void in
            
            make.height.equalTo(CavyDefine.spacingWidth25 * 6 + 0.3)
            make.left.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(CavyDefine.spacingWidth25 * 2))
            make.top.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 8)
        }
        
    }
    
    /**
     定义输入框布局
     */
    func defineTextFieldLayer() {
        
        passwdTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textFieldView).offset(CavyDefine.spacingWidth25)
            make.right.equalTo(textFieldView).offset(-CavyDefine.spacingWidth25)
        }
        
        userNameTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textFieldView).offset(CavyDefine.spacingWidth25)
            make.right.equalTo(textFieldView).offset(-CavyDefine.spacingWidth25)
        }
        
    }
    
    /**
     定义按钮布局
     */
    func defineButtonLayer() {
        
        signInBtn.snp_makeConstraints { (make) -> Void in
            
            make.left.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(CavyDefine.spacingWidth25 * 2))
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
        forgetPasswdBtn.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
    }

    /**
     点击右侧按钮
     
     - parameter sender:
     */
    override func onClickRight(sender: AnyObject) {

        let guideVC = StoryboardScene.Guide.instantiateGuideView()
        guideVC.viewStyle = .BandBluetooth
        self.pushVC(guideVC)

    }

    /**
     点击忘记密码
     
     - parameter sender:
     */
    @IBAction func onClickForgot(sender: AnyObject) {
        
        let forgotVC = StoryboardScene.Main.instantiateAccountManagerView()

        forgotVC.configView(PhoneForgotPwdViewModel())

        self.pushVC(forgotVC)

    }

    /**
     点击登录
     
     - parameter sender: 
     */
    @IBAction func onClickSignIn(sender: AnyObject) {

        signIn()
            
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

// MARK: - 文本框代理处理
extension SignInViewController {
    
    /**
     回车处理
     
     - parameter textField:
     
     - returns:
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        if textField == userNameTextField {
            passwdTextField.becomeFirstResponder()
        }
        
        if textField == passwdTextField {
            onClickSignIn(signInBtn)
        }
        
        return true
        
    }
    
}
