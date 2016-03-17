// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIColor {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}

extension UIColor {
  enum Name {
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case CameraBgColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 70% <br/> (0xffffffb3)
    case CameraChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 20% <br/> (0xffffff33)
    case CameraNoChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case ContactCellLine
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 5% <br/> (0x0000000d)
    case ContactCellSelect
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case ContactFindFriendDark
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case ContactFindFriendLight
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case ContactGroupLetter
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case ContactIntrouduce
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case ContactsName
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 20% <br/> (0x00000033)
    case GuideColor33
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case GuideColor66
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 60% <br/> (0x00000099)
    case GuideColor99
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1dbcff"></span>
    /// Alpha: 100% <br/> (0x1dbcffff)
    case GuideColorBlue
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 80% <br/> (0x000000cc)
    case GuideColorCC
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#048de2"></span>
    /// Alpha: 60% <br/> (0x048de299)
    case GuideColorGreen
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#38e7e1"></span>
    /// Alpha: 100% <br/> (0x38e7e1ff)
    case GuideColorcyanColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case GuideLineColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case HomeViewAccount
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 50% <br/> (0xffffff80)
    case HomeViewLeftHeaderLine
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 10% <br/> (0x0000001a)
    case HomeViewLeftSelected
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
    case HomeViewMainColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case HomeViewMaskColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case HomeViewUserName
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffd954"></span>
    /// Alpha: 100% <br/> (0xffd954ff)
    case MainPageBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b46e00"></span>
    /// Alpha: 100% <br/> (0xb46e00ff)
    case MainPageBtnText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ecbc46"></span>
    /// Alpha: 100% <br/> (0xecbc46ff)
    case MainPageSelectedBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 20% <br/> (0x00000033)
    case PageIndicatorTintColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1dbcff"></span>
    /// Alpha: 100% <br/> (0x1dbcffff)
    case SignInBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case SignInForgotPwdBtnText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case SignInMainTextColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1dbcff"></span>
    /// Alpha: 100% <br/> (0x1dbcffff)
    case SignInNavigationBar
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case SignInPlaceholderText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 20% <br/> (0x00000033)
    case SignInSplitLine
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 80% <br/> (0x000000cc)
    case SignInTextFieldText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#125fae"></span>
    /// Alpha: 100% <br/> (0x125faeff)
    case SignUpProtocolBtn

    var rgbaValue: UInt32! {
      switch self {
      case .CameraBgColor: return 0x000000ff
      case .CameraChoose: return 0xffffffb3
      case .CameraNoChoose: return 0xffffff33
      case .ContactCellLine: return 0xccccccff
      case .ContactCellSelect: return 0x0000000d
      case .ContactFindFriendDark: return 0xffffffff
      case .ContactFindFriendLight: return 0x00000080
      case .ContactGroupLetter: return 0x000000b3
      case .ContactIntrouduce: return 0x0000004d
      case .ContactsName: return 0x000000ff
      case .GuideColor33: return 0x00000033
      case .GuideColor66: return 0x00000066
      case .GuideColor99: return 0x00000099
      case .GuideColorBlue: return 0x1dbcffff
      case .GuideColorCC: return 0x000000cc
      case .GuideColorGreen: return 0x048de299
      case .GuideColorcyanColor: return 0x38e7e1ff
      case .GuideLineColor: return 0xccccccff
      case .HomeViewAccount: return 0x00000080
      case .HomeViewLeftHeaderLine: return 0xffffff80
      case .HomeViewLeftSelected: return 0x0000001a
      case .HomeViewMainColor: return 0x48d299ff
      case .HomeViewMaskColor: return 0x00000066
      case .HomeViewUserName: return 0x000000b3
      case .MainPageBtn: return 0xffd954ff
      case .MainPageBtnText: return 0xb46e00ff
      case .MainPageSelectedBtn: return 0xecbc46ff
      case .PageIndicatorTintColor: return 0x00000033
      case .SignInBackground: return 0x1dbcffff
      case .SignInForgotPwdBtnText: return 0x00000066
      case .SignInMainTextColor: return 0x00000080
      case .SignInNavigationBar: return 0x1dbcffff
      case .SignInPlaceholderText: return 0x00000066
      case .SignInSplitLine: return 0x00000033
      case .SignInTextFieldText: return 0x000000cc
      case .SignUpProtocolBtn: return 0x125faeff
      }
    }
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rgbaValue)
  }
}

