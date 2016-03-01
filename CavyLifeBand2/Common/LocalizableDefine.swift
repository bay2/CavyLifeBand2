// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation

enum L10n {
  /// 登入
  case MainPageSignInBtn
  /// 加入豚鼠
  case MainPageSignUpBtn
  /// 登录
  case SignInSignInBtn
  /// 手机/邮箱
  case SignInUserNameTextField
  /// 密码
  case SignInPasswdTextField
  /// 准备开始
  case SignInTitle
  /// 注册
  case SignInSignUpItemBtn
  /// 忘记了密码？
  case SignInForgotPasswdBtn
  /// 邮箱
  case SignUpPhoneRightItemBtn
  /// 手机
  case SignUpEmailRightItemBtn
  /// 加入豚鼠
  case SignUpTitle
  /// 手机
  case SignUpPhoneNumTextField
  /// 邮箱
  case SignUpEmailTextField
  /// 验证码
  case SignUpSafetyCodeTextField
  /// 发送验证码
  case SignUpSendSafetyCode
  /// 我们已经阅读并接受
  case SignUpProcotolViewTitle
  /// 《豚鼠科技服务协议》
  case SignUpProcotolViewBtn
  /// 注册
  case SignUpSignUpBtn
  /// 忘记密码了?
  case ForgotTitle
  /// 新密码
  case ForgotPasswdTextField
  /// 且慢,我想起来了!
  case ForgotBackTextBtn
  /// 完成
  case ForgotFinish
}

extension L10n : CustomStringConvertible {
  var description : String { return self.string }

  var string : String {
    switch self {
      case .MainPageSignInBtn:
        return L10n.tr("MainPage.SignInBtn")
      case .MainPageSignUpBtn:
        return L10n.tr("MainPage.SignUpBtn")
      case .SignInSignInBtn:
        return L10n.tr("SignIn.SignInBtn")
      case .SignInUserNameTextField:
        return L10n.tr("SignIn.UserNameTextField")
      case .SignInPasswdTextField:
        return L10n.tr("SignIn.PasswdTextField")
      case .SignInTitle:
        return L10n.tr("SignIn.title")
      case .SignInSignUpItemBtn:
        return L10n.tr("SignIn.SignUpItemBtn")
      case .SignInForgotPasswdBtn:
        return L10n.tr("SignIn.ForgotPasswdBtn")
      case .SignUpPhoneRightItemBtn:
        return L10n.tr("SignUp.PhoneRightItemBtn")
      case .SignUpEmailRightItemBtn:
        return L10n.tr("SignUp.EmailRightItemBtn")
      case .SignUpTitle:
        return L10n.tr("SignUp.Title")
      case .SignUpPhoneNumTextField:
        return L10n.tr("SignUp.PhoneNumTextField")
      case .SignUpEmailTextField:
        return L10n.tr("SignUp.EmailTextField")
      case .SignUpSafetyCodeTextField:
        return L10n.tr("SignUp.SafetyCodeTextField")
      case .SignUpSendSafetyCode:
        return L10n.tr("SignUp.SendSafetyCode")
      case .SignUpProcotolViewTitle:
        return L10n.tr("SignUp.ProcotolViewTitle")
      case .SignUpProcotolViewBtn:
        return L10n.tr("SignUp.ProcotolViewBtn")
      case .SignUpSignUpBtn:
        return L10n.tr("SignUp.SignUpBtn")
      case .ForgotTitle:
        return L10n.tr("Forgot.Title")
      case .ForgotPasswdTextField:
        return L10n.tr("Forgot.PasswdTextField")
      case .ForgotBackTextBtn:
        return L10n.tr("Forgot.BackTextBtn")
      case .ForgotFinish:
        return L10n.tr("Forgot.finish")
    }
  }

  private static func tr(key: String, _ args: CVarArgType...) -> String {
    let format = NSLocalizedString(key, comment: "")
    return String(format: format, arguments: args)
  }
}

func tr(key: L10n) -> String {
  return key.string
}

