//
//  SignUpViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions
import Alamofire
import AlamofireImage
import Log


class AccountManagerViewController: AccountManagerBaseViewController {
    
    enum UserViewStyle {
        
        case PhoneNumSignUp
        case EmailSignUp
        case PhoneNumForgotPasswd
        case EmailForgotPasswd
        
    }

    // 手机输入框
    @IBOutlet weak var userNameTextField: AccountTextField!
    
    // 安全码输入框
    @IBOutlet weak var safetyCodeTextField: AccountTextField!
    
    // 密码输入框
    @IBOutlet weak var passwdTextField: AccountTextField!
    
    // 发送验证码按钮
    @IBOutlet weak var safetyCodeBtn: SendSafetyCodeButton!
    
    // 邮箱验证码
    @IBOutlet weak var emailSafetyCode: UIImageView!
    
    // 返回登录按钮
    @IBOutlet weak var backSignInBtn: UIButton!
    
    // 主按钮
    @IBOutlet weak var mainBtn: MainPageButton!
    
    // 用户协议框
    @IBOutlet weak var userProtocolView: UserProtocolView!
   
    // 输入框视图
    @IBOutlet weak var textFieldView: UIView!
    
    // 垂直分割线
    @IBOutlet weak var verticalLine: UIView!

    // 视图风格
    var viewStyle: UserViewStyle = .PhoneNumSignUp

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTextFieldViewUI(textFieldView)

        updateViewStyle()

        setSubViewsTitle()

        defineSubViewsLayout()

        refreshEmailSafetyCode()
        
        emailSafetyCode.userInteractionEnabled = true
        emailSafetyCode.addTapGesture(target: self, action: "refreshEmailSafetyCode")
        
        userNameTextField.becomeFirstResponder()
        userNameTextField.backgroundColor = UIColor.whiteColor()
        passwdTextField.backgroundColor = UIColor.whiteColor()
        safetyCodeTextField.backgroundColor = UIColor.whiteColor()

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

        safetyCodeTextField.placeholder = L10n.SignUpSafetyCodeTextField.string
        safetyCodeBtn.setTitle(L10n.SignUpSendSafetyCode.string, forState: .Normal)
        backSignInBtn.setTitleColor(UIColor(named: .SignInForgotPwdBtnText), forState: .Normal)
        backSignInBtn.titleLabel!.font = UIFont.systemFontOfSize(14)

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
            
            make.top.equalTo(self.view).offset(spacingWidth25 * 8)
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
        
        emailSafetyCode.snp_makeConstraints { (make) -> Void in
            let imageSpacing = spacingWidth25 * 3 / 5
            make.height.equalTo(imageSpacing * 3)
            make.width.equalTo(imageSpacing * 8)
            make.top.equalTo(userNameTextField.snp_bottom).offset(imageSpacing + 0.3)
            make.left.equalTo(safetyCodeTextField.snp_right).offset(imageSpacing + 0.3)
        }
    }

    /**
     定义按钮布局
     */
    func defineButtonLayout() {
        
        mainBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textFieldView.snp_bottom).offset(spacingWidth25 * 3)
            make.left.equalTo(self.view).offset(spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(spacingWidth25 * 2))
            make.height.equalTo(spacingWidth25 * 3)
        }
        
        backSignInBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textFieldView.snp_bottom)
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

        userNameTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textFieldView).offset(spacingWidth25)
            make.right.equalTo(textFieldView).offset(-spacingWidth25)
        }
        
        safetyCodeTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(userNameTextField)
        }
        
        passwdTextField.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(userNameTextField)
        }
        
    }
    

    /**
     更新视图风格
     */
    func updateViewStyle() {

        var itemTitle = L10n.SignUpSendSafetyCode.string
        var itemRightTitle = L10n.SignUpPhoneRightItemBtn.string
        var viewMainBtn = L10n.SignUpSignUpBtn.string
        var userNameTextFieldTitle = L10n.SignUpPhoneNumTextField.string
        var passwdTextFieldTitle = L10n.SignInPasswdTextField.string

        switch viewStyle {

            case .PhoneNumSignUp:
                userProtocolView.hidden = false
                itemTitle = L10n.SignUpTitle.string
                itemRightTitle = L10n.SignUpPhoneRightItemBtn.string
                userNameTextFieldTitle = L10n.SignUpPhoneNumTextField.string
                passwdTextFieldTitle = L10n.SignInPasswdTextField.string
                viewMainBtn = L10n.SignUpSignUpBtn.string
                break

            case .EmailSignUp:
                userProtocolView.hidden = false
                itemTitle = L10n.SignUpTitle.string
                itemRightTitle = L10n.SignUpEmailRightItemBtn.string
                userNameTextFieldTitle = L10n.SignUpEmailTextField.string
                passwdTextFieldTitle = L10n.SignInPasswdTextField.string
                viewMainBtn = L10n.SignUpSignUpBtn.string
                emailSafetyCode.hidden = false
                safetyCodeBtn.hidden = true
                break

            case  .PhoneNumForgotPasswd:
                userProtocolView.hidden = true
                itemTitle = L10n.ForgotTitle.string
                itemRightTitle = L10n.SignUpPhoneRightItemBtn.string
                userNameTextFieldTitle = L10n.SignUpPhoneNumTextField.string
                passwdTextFieldTitle = L10n.ForgotPasswdTextField.string
                viewMainBtn = L10n.ForgotFinish.string
                userProtocolView.hidden = true
                backSignInBtn.hidden = false
                break

            case .EmailForgotPasswd:
                userProtocolView.hidden = true
                itemTitle = L10n.ForgotTitle.string
                itemRightTitle = L10n.SignUpEmailRightItemBtn.string
                userNameTextFieldTitle = L10n.SignUpEmailTextField.string
                passwdTextFieldTitle = L10n.ForgotPasswdTextField.string
                viewMainBtn = L10n.ForgotFinish.string
                emailSafetyCode.hidden = false
                safetyCodeBtn.hidden = true
                userProtocolView.hidden = true
                backSignInBtn.hidden = false
                break

        }

        userNameTextField.placeholder = userNameTextFieldTitle
        passwdTextField.placeholder = passwdTextFieldTitle
        mainBtn.setTitle(viewMainBtn, forState: .Normal)
        updateNavigationItemUI(itemTitle, rightBtnText: itemRightTitle)

    }

    /**
     点击右侧按钮
     
     - parameter sender:
     */
    override func onClickRight(sender: AnyObject) {

        super.onClickRight(sender)

        let nextView = StoryboardScene.Main.instantiateAccountManagerView()
        

        switch viewStyle {

            case .PhoneNumSignUp:
                nextView.viewStyle = .EmailSignUp
                self.pushVC(nextView)

            case .EmailSignUp:
                self.popVC()

            case  .PhoneNumForgotPasswd:
                nextView.viewStyle = .EmailForgotPasswd
                self.pushVC(nextView)

            case .EmailForgotPasswd:
                self.popVC()
            

        }

    }


    /**
     刷新邮箱验证码
     */
    func refreshEmailSafetyCode() {

        
        Alamofire.request(.GET, emailCodeAddr).responseImage { (response) -> Void in
            
            if let image = response.result.value {
                
                    self.emailSafetyCode.image = image
            }
            
        }
        
    }

    /**
     返回登录页面
     
     - parameter sender:
     */
    @IBAction func onClickBackSignIn(sender: AnyObject) {
        
        self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        
    }

    /**
     点击主按钮
     
     - parameter sender:
     */
    @IBAction func onClickMainBtn(sender: AnyObject) {

        let signUpViewModel = SignUpViewModel(viewController: self, userName: userNameTextField.text!, passwd: passwdTextField.text!, safetyCode: safetyCodeTextField.text!)

        let forgotViewModel = ForgotPasswordViewModel(viewController: self, userName: userNameTextField.text!, passwd: passwdTextField.text!, safetyCode: safetyCodeTextField.text!) {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[0])!, animated: true)
        }
        
        if userProtocolView.checkboxBtn.isCheck != true {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, title: "", message: L10n.SignUpReadProcotol.string)
            return
            
        }

        switch viewStyle {

            case .EmailSignUp:
                signUpViewModel.emailSignUp()

            case .PhoneNumSignUp:
                signUpViewModel.phoneSignUp()

            case .EmailForgotPasswd:
                forgotViewModel.emailForgotPwd()

            case .PhoneNumForgotPasswd:
                forgotViewModel.phoneForgotPwd()

        }

    }

    /**
     点击发送验证码
     
     - parameter sender: 
     */
    @IBAction func onClickSendSafetyCode(sender: AnyObject) {

        let sendSafetyCode = SendSafetyCodeViewModel(viewController: self, button: safetyCodeBtn, userName: userNameTextField.text!) {

            self.safetyCodeBtn.countDown()

        }

        sendSafetyCode.sendSafetyCode()

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

extension AccountManagerViewController {
    
    /**
     输入限制
     
     - parameter textField:
     
     - returns:
     */
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField != safetyCodeTextField {
            return true
        }
        
        if string == "" {
            return true
        }
        
        let newString = textField.text! + string
        
        if newString.length > 4 {
            textField.text = newString[0...3]
            return false
        }
        
        if viewStyle == .PhoneNumForgotPasswd || viewStyle == .PhoneNumSignUp {
            
            guard let _ = newString.toInt() else {
                return false
            }
            
        }
        
        return true
        
    }
    
    /**
     回车处理
     
     - parameter textField: 文本框
     
     - returns:
     */
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        switch  textField {
        case userNameTextField:
            safetyCodeTextField.becomeFirstResponder()
        case safetyCodeTextField:
            passwdTextField.becomeFirstResponder()
        default:
            onClickMainBtn(mainBtn)
        }
        
        return true
        
    }
    
}
