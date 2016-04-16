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

class AccountManagerViewController: UIViewController {
    
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
    
    var dataSource: AccountManagerViewDataSource?
    
    // 垂直分割线
    @IBOutlet weak var verticalLine: UIView!
    
    // 忘记密码返回页面
    var popToViewController: UIViewController {
        return self.navigationController!.viewControllers[0]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setSubViewsTitle()

        defineSubViewsLayout()

        refreshEmailSafetyCode()
        
        emailSafetyCode.userInteractionEnabled = true
        emailSafetyCode.addTapGesture(target: self, action: #selector(AccountManagerViewController.refreshEmailSafetyCode))
        
        userNameTextField.becomeFirstResponder()
        userNameTextField.backgroundColor = UIColor.whiteColor()
        passwdTextField.backgroundColor = UIColor.whiteColor()
        safetyCodeTextField.backgroundColor = UIColor.whiteColor()
        
        updateUI(textFieldView)
        
        setViewStyle()

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
            
            make.top.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 8)
            make.left.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(CavyDefine.spacingWidth25 * 2))

            if (UIScreen.mainScreen().scale == 2) {         // tailor:disable
                make.height.equalTo((CavyDefine.spacingWidth25 * 3) * 3 + 1)
            } else {
                make.height.equalTo((CavyDefine.spacingWidth25 * 3) * 3 + 0.3)
            }

        }
        
        userProtocolView.snp_makeConstraints { (make) -> Void in
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
            make.width.equalTo(280)
        }
        
        verticalLine.snp_makeConstraints { (make) -> Void in
            make.height.equalTo((CavyDefine.spacingWidth25 * 3 / 5) * 3)
        }
        
        emailSafetyCode.snp_makeConstraints { (make) -> Void in
            let imageSpacing = CavyDefine.spacingWidth25 * 3 / 5
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
            make.top.equalTo(textFieldView.snp_bottom).offset(CavyDefine.spacingWidth25 * 3)
            make.left.equalTo(self.view).offset(CavyDefine.spacingWidth25 * 2)
            make.right.equalTo(self.view).offset(-(CavyDefine.spacingWidth25 * 2))
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
        backSignInBtn.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(textFieldView.snp_bottom)
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
        safetyCodeBtn.snp_makeConstraints { (make) -> Void in
            make.width.equalTo((CavyDefine.spacingWidth25 * 3 / 5) * 9)
            make.right.equalTo(-CavyDefine.spacingWidth25)
        }

    }

    /**
     定义输入框布局
     */
    func defineTextFieldLayout() {

        userNameTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(textFieldView).offset(CavyDefine.spacingWidth25)
            make.right.equalTo(textFieldView).offset(-CavyDefine.spacingWidth25)
        }
        
        safetyCodeTextField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(userNameTextField)
        }
        
        passwdTextField.snp_makeConstraints { (make) -> Void in
            make.left.right.equalTo(userNameTextField)
        }
        
    }
    
    /**
     设置视图
     */
    func setViewStyle() {
        
        userNameTextField.placeholder = dataSource!.userNameTextFieldTitle
        passwdTextField.placeholder = dataSource!.passwdTextFieldTitle
        mainBtn.setTitle(dataSource!.viewMainBtnTitle, forState: .Normal)
        
        backSignInBtn.hidden = dataSource!.isSignUp
        userProtocolView.hidden = !dataSource!.isSignUp
        
        safetyCodeBtn.hidden = dataSource!.isEmail
        emailSafetyCode.hidden = !dataSource!.isEmail
        
        updateNavigationItemUI(dataSource!.navTitle, rightBtnTitle: dataSource!.itemRightTitle)
    }
    
    /**
     视图配置
     
     - parameter dataSource: AccountManagerViewDataSource
     */
    func configView(dataSource: AccountManagerViewDataSource) {
        
        self.dataSource = dataSource
        
    }

    /**
     点击右侧按钮
     
     - parameter sender:
     */
     func onClickRightBtn() {

        var viewModel: AccountManagerViewDataSource?
        let nextView = StoryboardScene.Main.instantiateAccountManagerView()
        
        if dataSource?.itemRightTitle == L10n.SignUpEmailRightItemBtn.string {
            
            self.popVC()
            return
            
        }
        
        if dataSource?.isSignUp == true {
            viewModel = EmailSignUpViewModel()
        } else {
            viewModel = EmailForgotPwdViewModel()
        }
        
        nextView.configView(viewModel!)
        
        self.pushVC(nextView)
        
    }


    /**
     刷新邮箱验证码
     */
    func refreshEmailSafetyCode() {
        
        Alamofire.request(.GET, CavyDefine.emailCodeAddr).responseImage { (response) -> Void in
            
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
        
        if userProtocolView.checkboxBtn.isCheck != true {
            
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: L10n.SignUpReadProcotol.string)
            return
            
        }
        
        guard checkInputIsNil() else {
            return
        }
        
        if dataSource?.isSignUp == true {
            
            signUp() {
                GuideUserInfo.userInfo.userId = $0
                GuideUserInfo.userInfo.updateUserInfo()
            }
            
        } else {
            
            forgotPwd()
            
        }

    }
    

    /**
     点击发送验证码
     
     - parameter sender: 
     */
    @IBAction func onClickSendSafetyCode(sender: AnyObject) {

        sendSafetyCode()
        
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
        
        if dataSource?.itemRightTitle == L10n.SignUpPhoneRightItemBtn.string {
            
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

extension AccountManagerViewController: SignUpDelegate, ForgotPasswordDelegate, SendSafetyCodeDelegate, AccountMangerInputCheckDelegate, UserViewControllerPresentable {
    
    var userName: String {
        return userNameTextField.text!
    }
    
    var passwd: String {
        return passwdTextField.text!
    }
    
    var safetyCode: String {
        return safetyCodeTextField.text!
    }
    
    var sendSafetyCodeBtn: SendSafetyCodeButton {
        return self.safetyCodeBtn
    }
    
    var isEmail: Bool {
        return dataSource!.isEmail
    }
    
}
