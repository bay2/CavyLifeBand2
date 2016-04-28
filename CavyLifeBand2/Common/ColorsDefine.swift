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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f2"></span>
    /// Alpha: 100% <br/> (0xf2f2f2ff)
    case AlarmClockDateBtnBGNormalColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff993f"></span>
    /// Alpha: 100% <br/> (0xff993fff)
    case AlarmClockDateBtnBGSelectedColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#858585"></span>
    /// Alpha: 100% <br/> (0x858585ff)
    case AlarmClockDateBtnTextNormalColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case AlarmClockDateBtnTextSelectedColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dbdbdb"></span>
    /// Alpha: 100% <br/> (0xdbdbdbff)
    case AlarmClockDeleteBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case AlarmClockSettingDescription2Color
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case AlarmClockSettingDescriptionColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case AlarmClockSettingTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case AlarmClockTableCellDescriptionColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case AlarmClockTableCellTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case CameraBgColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 70% <br/> (0xffffffb3)
    case CameraChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 20% <br/> (0xffffff33)
    case CameraNoChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff6d01"></span>
    /// Alpha: 100% <br/> (0xff6d01ff)
    case ContactsAccountLogoutButton
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff9138"></span>
    /// Alpha: 100% <br/> (0xff9138ff)
    case ContactsAddFriendButtonColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0dcf7f"></span>
    /// Alpha: 100% <br/> (0x0dcf7fff)
    case ContactsAgreeButtonColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff5656"></span>
    /// Alpha: 100% <br/> (0xff5656ff)
    case ContactsCareBtnColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case ContactsCellLine
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 5% <br/> (0x0000000d)
    case ContactsCellSelect
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#d9d9d9"></span>
    /// Alpha: 100% <br/> (0xd9d9d9ff)
    case ContactsDeleteBtnColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case ContactsFindFriendDark
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case ContactsFindFriendLight
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case ContactsIntrouduce
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case ContactsLetterColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case ContactsName
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff9f22"></span>
    /// Alpha: 100% <br/> (0xff9f22ff)
    case ContactsPKBtnColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e6e6e6"></span>
    /// Alpha: 100% <br/> (0xe6e6e6ff)
    case ContactsSearchBarColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 40% <br/> (0xffffff66)
    case ContactsSearchFlagViewBg
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f2"></span>
    /// Alpha: 100% <br/> (0xf2f2f2ff)
    case ContactsSectionColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case ContactsTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#929292"></span>
    /// Alpha: 100% <br/> (0x929292ff)
    case ContactsUndoCareBtnColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#38e797"></span>
    /// Alpha: 100% <br/> (0x38e797ff)
    case GuideBandBluetoothColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case GuideBirthRulerLineColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 20% <br/> (0x00000033)
    case GuideColor33
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case GuideColor66
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 60% <br/> (0x00000099)
    case GuideColor99
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 80% <br/> (0x000000cc)
    case GuideColorCC
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case GuideLineColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1dbcff"></span>
    /// Alpha: 100% <br/> (0x1dbcffff)
    case GuideSetInfoColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
    case GuideSetPermission
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e5e5e5"></span>
    /// Alpha: 100% <br/> (0xe5e5e5ff)
    case HomeDetailBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case HomeDetailDeselectText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#309a6e"></span>
    /// Alpha: 100% <br/> (0x309a6eff)
    case HomeRingViewBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#36f3ff"></span>
    /// Alpha: 100% <br/> (0x36f3ffff)
    case HomeSleepRingColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fff956"></span>
    /// Alpha: 100% <br/> (0xfff956ff)
    case HomeStepRingColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e5e5e5"></span>
    /// Alpha: 100% <br/> (0xe5e5e5ff)
    case HomeTimeLineLineColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff8259"></span>
    /// Alpha: 100% <br/> (0xff8259ff)
    case HomeTimeLinePKCellTextColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case SettingSeparatorColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case SettingTableCellInfoGrayColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff9138"></span>
    /// Alpha: 100% <br/> (0xff9138ff)
    case SettingTableCellInfoYellowColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case SettingTableCellTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case SettingTableFooterInfoColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#125fae"></span>
    /// Alpha: 100% <br/> (0x125faeff)
    case SignUpProtocolBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 80% <br/> (0x000000cc)
    case TextFieldTextColor

    var rgbaValue: UInt32! {
      switch self {
      case .AlarmClockDateBtnBGNormalColor: return 0xf2f2f2ff
      case .AlarmClockDateBtnBGSelectedColor: return 0xff993fff
      case .AlarmClockDateBtnTextNormalColor: return 0x858585ff
      case .AlarmClockDateBtnTextSelectedColor: return 0xffffffff
      case .AlarmClockDeleteBtnBGColor: return 0xdbdbdbff
      case .AlarmClockSettingDescription2Color: return 0x0000004d
      case .AlarmClockSettingDescriptionColor: return 0x00000080
      case .AlarmClockSettingTitleColor: return 0x000000b3
      case .AlarmClockTableCellDescriptionColor: return 0x0000004d
      case .AlarmClockTableCellTitleColor: return 0x000000b3
      case .CameraBgColor: return 0x000000ff
      case .CameraChoose: return 0xffffffb3
      case .CameraNoChoose: return 0xffffff33
      case .ContactsAccountLogoutButton: return 0xff6d01ff
      case .ContactsAddFriendButtonColor: return 0xff9138ff
      case .ContactsAgreeButtonColor: return 0x0dcf7fff
      case .ContactsCareBtnColor: return 0xff5656ff
      case .ContactsCellLine: return 0xccccccff
      case .ContactsCellSelect: return 0x0000000d
      case .ContactsDeleteBtnColor: return 0xd9d9d9ff
      case .ContactsFindFriendDark: return 0xffffffff
      case .ContactsFindFriendLight: return 0x00000080
      case .ContactsIntrouduce: return 0x0000004d
      case .ContactsLetterColor: return 0x0000004d
      case .ContactsName: return 0x000000ff
      case .ContactsPKBtnColor: return 0xff9f22ff
      case .ContactsSearchBarColor: return 0xe6e6e6ff
      case .ContactsSearchFlagViewBg: return 0xffffff66
      case .ContactsSectionColor: return 0xf2f2f2ff
      case .ContactsTitleColor: return 0x000000b3
      case .ContactsUndoCareBtnColor: return 0x929292ff
      case .GuideBandBluetoothColor: return 0x38e797ff
      case .GuideBirthRulerLineColor: return 0x00000080
      case .GuideColor33: return 0x00000033
      case .GuideColor66: return 0x00000066
      case .GuideColor99: return 0x00000099
      case .GuideColorCC: return 0x000000cc
      case .GuideLineColor: return 0xccccccff
      case .GuideSetInfoColor: return 0x1dbcffff
      case .GuideSetPermission: return 0x48d299ff
      case .HomeDetailBackground: return 0xe5e5e5ff
      case .HomeDetailDeselectText: return 0x00000066
      case .HomeRingViewBackground: return 0x309a6eff
      case .HomeSleepRingColor: return 0x36f3ffff
      case .HomeStepRingColor: return 0xfff956ff
      case .HomeTimeLineLineColor: return 0xe5e5e5ff
      case .HomeTimeLinePKCellTextColor: return 0xff8259ff
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
      case .SettingSeparatorColor: return 0xccccccff
      case .SettingTableCellInfoGrayColor: return 0x0000004d
      case .SettingTableCellInfoYellowColor: return 0xff9138ff
      case .SettingTableCellTitleColor: return 0x000000b3
      case .SettingTableFooterInfoColor: return 0x00000080
      case .SignInBackground: return 0x48d299ff
      case .SignInForgotPwdBtnText: return 0x00000066
      case .SignInMainTextColor: return 0x00000080
      case .SignInNavigationBar: return 0x1dbcffff
      case .SignInPlaceholderText: return 0x00000066
      case .SignInSplitLine: return 0x00000033
      case .SignUpProtocolBtn: return 0x125faeff
      case .TextFieldTextColor: return 0x000000cc
      }
    }

    var color: UIColor {
      return UIColor(named: self)
    }
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rgbaValue)
  }
}

