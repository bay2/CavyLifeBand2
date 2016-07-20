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
import RealmSwift

class AccountManagerViewController: UIViewController, BaseViewControllerPresenter, UserInfoRealmOperateDelegate, LifeBandBleDelegate, SignInDelegate, QueryUserInfoRequestsDelegate{
    
    enum UserViewStyle {
        
        case PhoneNumSignUp
        case EmailSignUp
        case PhoneNumForgotPasswd
        case EmailForgotPasswd
        
    }
    
    var realm: Realm = try! Realm()
    
    @IBOutlet weak var lineConstraint: NSLayoutConstraint!
    // 手机输入框
    @IBOutlet weak var userNameTextField: AccountTextField!
    
    // 安全码输入框
    @IBOutlet weak var safetyCodeTextField: AccountTextField!
    
    // 密码输入框
    @IBOutlet weak var passwdTextField: AccountTextField!
    
    // 发送验证码按钮
    @IBOutlet weak var safetyCodeBtn: SendSafetyCodeButton!
    
    // 返回登录按钮
    @IBOutlet weak var backSignInBtn: UIButton!
    
    // 主按钮
    @IBOutlet weak var mainBtn: MainPageButton!
    
    // 用户协议框
    @IBOutlet weak var userProtocolView: UserProtocolView!
    
    // 输入框视图
    @IBOutlet weak var textFieldView: UIView!
    
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var dataSource: AccountManagerViewDataSource?
    
    var navTitle: String {
        return dataSource?.navTitle ?? ""
    }
    
    lazy var rightBtn: UIButton? =  {
        
        let button = UIButton(type: .System)
        button.setTitleColor(UIColor(named: .AColor), forState: .Normal)
        button.frame = CGRectMake(0, 0, 60, 30)
        button.titleLabel?.font = UIFont.mediumSystemFontOfSize(14)
        return button
        
    }()
    
    
    var leftBtn: UIButton? = {
        
        let leftItemBtn = UIButton(frame: CGRectMake(0, 0, 30, 30))
        leftItemBtn.setBackgroundImage(UIImage(asset: .Backbtn), forState: .Normal)
        return leftItemBtn
        
    }()
    
    
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
     
        userProtocolView.protocolBtn.addTarget(self, action: #selector(AccountManagerViewController.protocolBtnDown), forControlEvents: .TouchUpInside)
        userNameTextField.becomeFirstResponder()
        userNameTextField.backgroundColor = UIColor.whiteColor()
        passwdTextField.backgroundColor = UIColor.whiteColor()
        safetyCodeTextField.backgroundColor = UIColor.whiteColor()
        
        textFieldView.backgroundColor = UIColor.whiteColor()
        textFieldView.layer.cornerRadius = CavyDefine.commonCornerRadius
        
        if UIDevice.isPhone5() || UIDevice.isPhone4() {
            
            lineConstraint.constant = 0.5
        }
        
        
        rightBtn?.setTitle(dataSource?.itemRightTitle, forState: .Normal)
        
        self.view.backgroundColor = UIColor(named: .HomeViewMainColor)
        
        setViewStyle()
        
        addLodingView()
        
        updateNavUI()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
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
     协议跳转
     */
    
    func protocolBtnDown()  {
        
        let targetVC = WebViewController()
        
        targetVC.dataSource = RegisterProtoclWeb()
        
        self.pushVC(targetVC)
        
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
        
        textFieldView.snp_makeConstraints { make -> Void in
            
            make.top.equalTo(self.view).offset(16)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            
            if (UIScreen.mainScreen().scale == 2) {         // tailor:disable
                make.height.equalTo((CavyDefine.spacingWidth25 * 3) * 3 + 1)
            } else {
                make.height.equalTo((CavyDefine.spacingWidth25 * 3) * 3 + 0.3)
            }
            
        }
        
        userProtocolView.snp_makeConstraints { make -> Void in
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
            make.width.equalTo(280)
        }
        
        verticalLine.snp_makeConstraints { make -> Void in
            make.height.equalTo((CavyDefine.spacingWidth25 * 3 / 5) * 3)
            make.right.equalTo(self.textFieldView).offset(-110)
        }
        
    }
    
    /**
     定义按钮布局
     */
    func defineButtonLayout() {
        
        mainBtn.snp_makeConstraints { make -> Void in
            make.top.equalTo(textFieldView.snp_bottom).offset(CavyDefine.spacingWidth25 * 3)
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
        backSignInBtn.snp_makeConstraints { make -> Void in
            make.top.equalTo(textFieldView.snp_bottom)
            make.height.equalTo(CavyDefine.spacingWidth25 * 3)
        }
        
        safetyCodeBtn.snp_makeConstraints { make -> Void in
            make.width.equalTo(90)
            make.right.equalTo(self.textFieldView).offset(-20)
        }
        
    }
    
    /**
     定义输入框布局
     */
    func defineTextFieldLayout() {
        
        userNameTextField.snp_makeConstraints { make -> Void in
            make.left.equalTo(textFieldView).offset(20)
            make.right.equalTo(textFieldView).offset(-20)
        }
        
        safetyCodeTextField.snp_makeConstraints { make -> Void in
            make.left.equalTo(userNameTextField)
        }
        
        passwdTextField.snp_makeConstraints { make -> Void in
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
    func onRightBtn() {
        
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
        
        //        ez.topMostVC?.pushVC(nextView)
        
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
            loadingView.startAnimating()
            signUp((dataSource?.isEmail)!, successBack: { [unowned self] in
                
                GuideUserInfo.userInfo.userId = $0
                
                let userInfoModel = UserInfoModel(guideUserinfo: GuideUserInfo.userInfo)
                userInfoModel.isSync = false
                self.addUserInfo(userInfoModel)
                
                // 注册成功之后走登录流程
                self.singIn()
                
            }, failBack: { [unowned self] (msg) in
                self.loadingView.stopAnimating()
                self.signUpOrCodeFail(msg)
            })
            
        } else {
            
            if dataSource?.isEmail == true { forgetPwdEmail() } else { forgetPwdPhone() }
            
        }
        
    }
    
    
    
    
    func singIn() {
        
        signIn({
            
            // 登录绑定场景
            BindBandCtrl.bindScene = .SignInBind
            
            let guideVC = StoryboardScene.Guide.instantiateGuideView()
            
            let bindBandKey = "CavyAppMAC_" + CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
            
            // 查询不到用户信息，走绑定流程
            guard let bindBandValue = CavyDefine.bindBandInfos.bindBandInfo.userBindBand[bindBandKey] else {
                self.loadingView.stopAnimating()
                //用户未绑定，走绑定流程
                let guideVC = StoryboardScene.Guide.instantiateGuideView()
                let guideVM = GuideBandBluetooth()
                guideVC.configView(guideVM, delegate: guideVM)
                self.pushVC(guideVC)
                
                return
                
            }
            
            // 手环已绑定，记录手环信息，root 页面中会根据此属性设置绑定的手环
            //                GuideUserInfo.userInfo.bandName = bindBandValue
            BindBandCtrl.bandMacAddress = bindBandValue
            
            // 通过查询用户信息判断是否是老的豚鼠用户
            self.queryUserInfoByNet(self, failBack: {
                self.loadingView.stopAnimating()
            }) {
                self.loadingView.stopAnimating()
                guard let userProfile = $0 else {
                    return
                }
                
                // 老用户进入引导页
                if userProfile.sleepGoal == 0 {
                    
                    let guideVM = GuideGenderViewModel()
                    guideVC.configView(guideVM, delegate: guideVM)
                    self.pushVC(guideVC)
                    
                    
                } else {
                    
                    // 登录绑定
                    self.saveMacAddress()
                    UIApplication.sharedApplication().keyWindow?.setRootViewController(StoryboardScene.Home.instantiateRootView(), transition: CATransition())
                    
                }
                
            }
            
        }) {
            self.loadingView.stopAnimating()
        }
        
    }
    
    
    /**
     点击发送验证码
     
     - parameter sender: 
     */
    @IBAction func onClickSendSafetyCode(sender: AnyObject) {
        
        guard checkUsernameAvailable() == true else {
            return
        }
        
        if dataSource?.isSignUp == true {
            
            if dataSource?.isEmail == true {
                
                sendSignUpEmailCode{ [unowned self] (msg) in
                    self.signUpOrCodeFail(msg)
                }
                
            } else {
                sendSignUpPhoneCode{ [unowned self] (msg) in
                    self.signUpOrCodeFail(msg)
                }
            }
            
        } else {
            
            if dataSource?.isEmail == true { sendResetPwdEmailCode() }
            else { sendResetPwdPhoneCode() }
            
        }
        
    }
    
    /**
     验证码和注册接口失败处理
     
     - parameter msg: 
     */
    func signUpOrCodeFail(msg: CommenResponse) {
        
        if msg.code == RequestApiCode.AccountAlreadyExist.rawValue {
        
            let alertView = UIAlertController(title: "", message: msg.msg, preferredStyle: .Alert)
            
            let signInAction = UIAlertAction(title: L10n.SignUpDirectSinIn.string, style: .Cancel) { [unowned self] (action) in
                
                self.view.endEditing(true)
                
                self.presentViewController(UINavigationController(rootViewController: StoryboardScene.Main.instantiateSignInView()), animated: true, completion: nil)
                
            }
            
            let reSinUpAction = UIAlertAction(title: L10n.SignUpReSignUp.string, style: .Default) { [unowned self] (action) in
                self.userNameTextField.text = ""
                
                self.safetyCodeTextField.text = ""
                
                self.passwdTextField.text = ""
                
                self.userNameTextField.becomeFirstResponder()
            }
            
            alertView.addAction(signInAction)
            alertView.addAction(reSinUpAction)
            
            self.presentViewController(alertView, animated: true, completion: nil)
                        
        } else {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(self, message: msg.msg)
        }
        

    }
    
    
    func onLeftBtnBack() {
        
        self.view.endEditing(true)
        guard let _ = self.navigationController?.popViewControllerAnimated(true) else{
            
            self.dismissVC(completion: nil)
            
            return
        }
        
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
        
        if newString.length > 6 {
            textField.text = newString[0...5]
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

extension AccountManagerViewController: SignUpDelegate, ForgotPasswordDelegate, SendSafetyCodeDelegate, AccountMangerInputCheckDelegate {
    
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
