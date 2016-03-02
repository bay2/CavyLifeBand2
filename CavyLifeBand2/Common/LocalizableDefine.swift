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
  case SignUpRightItemBtn
  /// 加入豚鼠
  case SignUpTitle
  /// 手机
  case SignUpPhoneNumTextField
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
  /// 我的信息
  case GuideMyInfo
  /// 我是
  case GuideMine
  /// 生日
  case GuideBirthday
  /// 身高
  case GuideHeight
  /// 体重
  case GuideWeight
  /// 可以更好地帮助健康统计哦
  case GuideIntroduce
  /// 设置
  case GuideSetting
  /// 开启智能通知
  case GuideOpenNotice
  /// 随时关注我的健康生活
  case GuideOpenNoticeInfo
  /// 开启位置共享
  case GuideOpenLocationShare
  /// 告诉豚鼠你的位置，更有安全服务！
  case GuideOpenLocationShareInfo
  /// 连接手环
  case GuideLinkCavy
  /// 打开蓝牙
  case GuideOpenBluetooth
  /// 手机蓝牙打开后才能成功连接手环
  case GuideOpenBluetoothInfo
  /// 开启手环
  case GuideOpenCavy
  /// 没有灯充电试试看
  case GuideOpenCavySugg
  /// 按下手环按钮等待红灯亮起即打开手环
  case GuideOpenCavyInfo
  /// 正在连接...
  case GuideLinking
  /// 配对成功
  case GuidePairSuccess
  /// 开始健康之旅吧
  case GuidePairSuccessInfo
  /// 无法配对
  case GuidePairFail
  /// 确保手环有电，并且位于手机的连接范围
  case GuidePairFailInfo
}

extension L10n: CustomStringConvertible {
  var description: String { return self.string }

  var string: String {
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
      case .SignUpRightItemBtn:
        return L10n.tr("SignUp.RightItemBtn")
      case .SignUpTitle:
        return L10n.tr("SignUp.Title")
      case .SignUpPhoneNumTextField:
        return L10n.tr("SignUp.PhoneNumTextField")
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
      case .GuideMyInfo:
        return L10n.tr("Guide.MyInfo")
      case .GuideMine:
        return L10n.tr("Guide.Mine")
      case .GuideBirthday:
        return L10n.tr("Guide.Birthday")
      case .GuideHeight:
        return L10n.tr("Guide.Height")
      case .GuideWeight:
        return L10n.tr("Guide.Weight")
      case .GuideIntroduce:
        return L10n.tr("Guide.Introduce")
      case .GuideSetting:
        return L10n.tr("Guide.Setting")
      case .GuideOpenNotice:
        return L10n.tr("Guide.OpenNotice")
      case .GuideOpenNoticeInfo:
        return L10n.tr("Guide.OpenNoticeInfo")
      case .GuideOpenLocationShare:
        return L10n.tr("Guide.OpenLocationShare")
      case .GuideOpenLocationShareInfo:
        return L10n.tr("Guide.OpenLocationShareInfo")
      case .GuideLinkCavy:
        return L10n.tr("Guide.LinkCavy")
      case .GuideOpenBluetooth:
        return L10n.tr("Guide.OpenBluetooth")
      case .GuideOpenBluetoothInfo:
        return L10n.tr("Guide.OpenBluetoothInfo")
      case .GuideOpenCavy:
        return L10n.tr("Guide.OpenCavy")
      case .GuideOpenCavySugg:
        return L10n.tr("Guide.OpenCavySugg")
      case .GuideOpenCavyInfo:
        return L10n.tr("Guide.OpenCavyInfo")
      case .GuideLinking:
        return L10n.tr("Guide.Linking")
      case .GuidePairSuccess:
        return L10n.tr("Guide.PairSuccess")
      case .GuidePairSuccessInfo:
        return L10n.tr("Guide.PairSuccessInfo")
      case .GuidePairFail:
        return L10n.tr("Guide.PairFail")
      case .GuidePairFailInfo:
        return L10n.tr("Guide.PairFailInfo")
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
