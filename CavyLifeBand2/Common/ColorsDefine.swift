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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case AColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2b7e5c"></span>
    /// Alpha: 100% <br/> (0x2b7e5cff)
    case AlarmClockEmptyLabelColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#91e4c2"></span>
    /// Alpha: 100% <br/> (0x91e4c2ff)
    case BColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2b7e5c"></span>
    /// Alpha: 100% <br/> (0x2b7e5cff)
    case CColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case CameraBgColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 70% <br/> (0xffffffb3)
    case CameraChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 20% <br/> (0xffffff33)
    case CameraNoChoose
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e5e5e5"></span>
    /// Alpha: 100% <br/> (0xe5e5e5ff)
    case ChartBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 40% <br/> (0x00000066)
    case ChartDeselectText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 10% <br/> (0xffffff1a)
    case ChartGirdColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2db6cf"></span>
    /// Alpha: 100% <br/> (0x2db6cfff)
    case ChartSleepDegreeDeep
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#36f3ff"></span>
    /// Alpha: 100% <br/> (0x36f3ffff)
    case ChartSleepDegreeLight
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff5757"></span>
    /// Alpha: 100% <br/> (0xff5757ff)
    case ChartSleepDegreeText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#fff956"></span>
    /// Alpha: 100% <br/> (0xfff956ff)
    case ChartStepPillarColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cef4e3"></span>
    /// Alpha: 100% <br/> (0xcef4e3ff)
    case ChartSubTimeBucketTint
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b3efd5"></span>
    /// Alpha: 100% <br/> (0xb3efd5ff)
    case ChartSubTimeBucketTintMore
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#72e4b5"></span>
    /// Alpha: 100% <br/> (0x72e4b5ff)
    case ChartSubTimeBucketViewBg
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#4d4d4d"></span>
    /// Alpha: 100% <br/> (0x4d4d4dff)
    case ChartViewBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 30% <br/> (0xffffff4d)
    case ChartViewTextColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case ContactsTableEmptyTextColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case ContactsTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#929292"></span>
    /// Alpha: 100% <br/> (0x929292ff)
    case ContactsUndoCareBtnColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#3aa87a"></span>
    /// Alpha: 100% <br/> (0x3aa87aff)
    case DColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#585858"></span>
    /// Alpha: 100% <br/> (0x585858ff)
    case EColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b8b8b8"></span>
    /// Alpha: 100% <br/> (0xb8b8b8ff)
    case EmergencyContactCellAddBtnTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dddddd"></span>
    /// Alpha: 100% <br/> (0xddddddff)
    case EmergencyContactCellCancelBtnTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
    case EmergencyContactCellInfoLabelColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#8d8d8d"></span>
    /// Alpha: 100% <br/> (0x8d8d8dff)
    case FColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b8b8b8"></span>
    /// Alpha: 100% <br/> (0xb8b8b8ff)
    case GColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#cccccc"></span>
    /// Alpha: 100% <br/> (0xccccccff)
    case HColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff7200"></span>
    /// Alpha: 100% <br/> (0xff7200ff)
    case IColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff9138"></span>
    /// Alpha: 100% <br/> (0xff9138ff)
    case JColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
    case KColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e0e0e0"></span>
    /// Alpha: 100% <br/> (0xe0e0e0ff)
    case LColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f2f2f2"></span>
    /// Alpha: 100% <br/> (0xf2f2f2ff)
    case MColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffd954"></span>
    /// Alpha: 100% <br/> (0xffd954ff)
    case MainPageBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b46e00"></span>
    /// Alpha: 100% <br/> (0xb46e00ff)
    case MainPageBtnText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ecbc46"></span>
    /// Alpha: 100% <br/> (0xecbc46ff)
    case MainPageSelectedBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dddddd"></span>
    /// Alpha: 100% <br/> (0xddddddff)
    case NColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffd46c"></span>
    /// Alpha: 100% <br/> (0xffd46cff)
    case OColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b46e00"></span>
    /// Alpha: 100% <br/> (0xb46e00ff)
    case PColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case PKChallengeViewNormalTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff7200"></span>
    /// Alpha: 100% <br/> (0xff7200ff)
    case PKChallengeViewRulesTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff7200"></span>
    /// Alpha: 100% <br/> (0xff7200ff)
    case PKChallengeViewTopViewBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case PKInfoOrResultViewNormalTextColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff7200"></span>
    /// Alpha: 100% <br/> (0xff7200ff)
    case PKInfoOrResultViewWinnerTextColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case PKIntroduceVCLabelColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case PKInvitationVCLabelColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 30% <br/> (0x0000004d)
    case PKInvitationVCSeeStateBtnNormalColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case PKInvitationVCSeeStateBtnSelectedColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0dcf7f"></span>
    /// Alpha: 100% <br/> (0x0dcf7fff)
    case PKRecordsCellAcceptBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dbdbdb"></span>
    /// Alpha: 100% <br/> (0xdbdbdbff)
    case PKRecordsCellDeleteBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff9138"></span>
    /// Alpha: 100% <br/> (0xff9138ff)
    case PKRecordsCellPKAgainBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#dbdbdb"></span>
    /// Alpha: 100% <br/> (0xdbdbdbff)
    case PKRecordsCellUndoBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 50% <br/> (0x00000080)
    case PKRulesViewInfoColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 70% <br/> (0x000000b3)
    case PKRulesViewTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e5e5e5"></span>
    /// Alpha: 100% <br/> (0xe5e5e5ff)
    case PKTimePickerSeparatorColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 20% <br/> (0x00000033)
    case PageIndicatorTintColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff6749"></span>
    /// Alpha: 100% <br/> (0xff6749ff)
    case QColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case RColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#8d8d8d"></span>
    /// Alpha: 100% <br/> (0x8d8d8dff)
    case RalateAppCellImageBorderColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b8b8b8"></span>
    /// Alpha: 100% <br/> (0xb8b8b8ff)
    case RalateAppCellInfoColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#8d8d8d"></span>
    /// Alpha: 100% <br/> (0x8d8d8dff)
    case RalateAppCellSizeColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#585858"></span>
    /// Alpha: 100% <br/> (0x585858ff)
    case RalateAppCellTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f4f4f4"></span>
    /// Alpha: 100% <br/> (0xf4f4f4ff)
    case RalateAppTableBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#585858"></span>
    /// Alpha: 100% <br/> (0x585858ff)
    case RalateHelpFeedbackCellTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffd954"></span>
    /// Alpha: 100% <br/> (0xffd954ff)
    case RalateHelpFeedbackSendBtnBGColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b46e00"></span>
    /// Alpha: 100% <br/> (0xb46e00ff)
    case RalateHelpFeedbackSendBtnTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#b8b8b8"></span>
    /// Alpha: 100% <br/> (0xb8b8b8ff)
    case RalateHelpFeedbackTextViewPlaceHolderColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#333333"></span>
    /// Alpha: 100% <br/> (0x333333ff)
    case RelateAboutCellInfoColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#585858"></span>
    /// Alpha: 100% <br/> (0x585858ff)
    case RelateAboutCellTitleColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#91e4c2"></span>
    /// Alpha: 100% <br/> (0x91e4c2ff)
    case RelateAboutCopyrightColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2b7e5c"></span>
    /// Alpha: 100% <br/> (0x2b7e5cff)
    case RelateAboutUseAndPrivateColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff5656"></span>
    /// Alpha: 100% <br/> (0xff5656ff)
    case SColor
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
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
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#48d299"></span>
    /// Alpha: 100% <br/> (0x48d299ff)
    case UpdateProgressViewProgressColor
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
    /// Alpha: 100% <br/> (0x000000ff)
    case UpdateProgressViewTextColor

    var rgbaValue: UInt32! {
      switch self {
      case .AColor: return 0xffffffff
      case .AlarmClockDateBtnBGNormalColor: return 0xf2f2f2ff
      case .AlarmClockDateBtnBGSelectedColor: return 0xff993fff
      case .AlarmClockDateBtnTextNormalColor: return 0x858585ff
      case .AlarmClockDateBtnTextSelectedColor: return 0xffffffff
      case .AlarmClockDeleteBtnBGColor: return 0xdbdbdbff
      case .AlarmClockEmptyLabelColor: return 0x2b7e5cff
      case .AlarmClockSettingDescription2Color: return 0x0000004d
      case .AlarmClockSettingDescriptionColor: return 0x00000080
      case .AlarmClockSettingTitleColor: return 0x000000b3
      case .AlarmClockTableCellDescriptionColor: return 0x0000004d
      case .AlarmClockTableCellTitleColor: return 0x000000b3
      case .BColor: return 0x91e4c2ff
      case .CColor: return 0x2b7e5cff
      case .CameraBgColor: return 0x000000ff
      case .CameraChoose: return 0xffffffb3
      case .CameraNoChoose: return 0xffffff33
      case .ChartBackground: return 0xe5e5e5ff
      case .ChartDeselectText: return 0x00000066
      case .ChartGirdColor: return 0xffffff1a
      case .ChartSleepDegreeDeep: return 0x2db6cfff
      case .ChartSleepDegreeLight: return 0x36f3ffff
      case .ChartSleepDegreeText: return 0xff5757ff
      case .ChartStepPillarColor: return 0xfff956ff
      case .ChartSubTimeBucketTint: return 0xcef4e3ff
      case .ChartSubTimeBucketTintMore: return 0xb3efd5ff
      case .ChartSubTimeBucketViewBg: return 0x72e4b5ff
      case .ChartViewBackground: return 0x4d4d4dff
      case .ChartViewTextColor: return 0xffffff4d
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
      case .ContactsTableEmptyTextColor: return 0xccccccff
      case .ContactsTitleColor: return 0x000000b3
      case .ContactsUndoCareBtnColor: return 0x929292ff
      case .DColor: return 0x3aa87aff
      case .EColor: return 0x585858ff
      case .EmergencyContactCellAddBtnTitleColor: return 0xb8b8b8ff
      case .EmergencyContactCellCancelBtnTitleColor: return 0xddddddff
      case .EmergencyContactCellInfoLabelColor: return 0x48d299ff
      case .FColor: return 0x8d8d8dff
      case .GColor: return 0xb8b8b8ff
      case .GuideBandBluetoothColor: return 0x38e797ff
      case .GuideBirthRulerLineColor: return 0x00000080
      case .GuideColor33: return 0x00000033
      case .GuideColor66: return 0x00000066
      case .GuideColor99: return 0x00000099
      case .GuideColorCC: return 0x000000cc
      case .GuideLineColor: return 0xccccccff
      case .GuideSetInfoColor: return 0x1dbcffff
      case .GuideSetPermission: return 0x48d299ff
      case .HColor: return 0xccccccff
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
      case .IColor: return 0xff7200ff
      case .JColor: return 0xff9138ff
      case .KColor: return 0x48d299ff
      case .LColor: return 0xe0e0e0ff
      case .MColor: return 0xf2f2f2ff
      case .MainPageBtn: return 0xffd954ff
      case .MainPageBtnText: return 0xb46e00ff
      case .MainPageSelectedBtn: return 0xecbc46ff
      case .NColor: return 0xddddddff
      case .OColor: return 0xffd46cff
      case .PColor: return 0xb46e00ff
      case .PKChallengeViewNormalTitleColor: return 0x000000b3
      case .PKChallengeViewRulesTitleColor: return 0xff7200ff
      case .PKChallengeViewTopViewBGColor: return 0xff7200ff
      case .PKInfoOrResultViewNormalTextColor: return 0x000000b3
      case .PKInfoOrResultViewWinnerTextColor: return 0xff7200ff
      case .PKIntroduceVCLabelColor: return 0x00000080
      case .PKInvitationVCLabelColor: return 0x000000b3
      case .PKInvitationVCSeeStateBtnNormalColor: return 0x0000004d
      case .PKInvitationVCSeeStateBtnSelectedColor: return 0x000000b3
      case .PKRecordsCellAcceptBtnBGColor: return 0x0dcf7fff
      case .PKRecordsCellDeleteBtnBGColor: return 0xdbdbdbff
      case .PKRecordsCellPKAgainBtnBGColor: return 0xff9138ff
      case .PKRecordsCellUndoBtnBGColor: return 0xdbdbdbff
      case .PKRulesViewInfoColor: return 0x00000080
      case .PKRulesViewTitleColor: return 0x000000b3
      case .PKTimePickerSeparatorColor: return 0xe5e5e5ff
      case .PageIndicatorTintColor: return 0x00000033
      case .QColor: return 0xff6749ff
      case .RColor: return 0x000000ff
      case .RalateAppCellImageBorderColor: return 0x8d8d8dff
      case .RalateAppCellInfoColor: return 0xb8b8b8ff
      case .RalateAppCellSizeColor: return 0x8d8d8dff
      case .RalateAppCellTitleColor: return 0x585858ff
      case .RalateAppTableBGColor: return 0xf4f4f4ff
      case .RalateHelpFeedbackCellTitleColor: return 0x585858ff
      case .RalateHelpFeedbackSendBtnBGColor: return 0xffd954ff
      case .RalateHelpFeedbackSendBtnTitleColor: return 0xb46e00ff
      case .RalateHelpFeedbackTextViewPlaceHolderColor: return 0xb8b8b8ff
      case .RelateAboutCellInfoColor: return 0x333333ff
      case .RelateAboutCellTitleColor: return 0x585858ff
      case .RelateAboutCopyrightColor: return 0x91e4c2ff
      case .RelateAboutUseAndPrivateColor: return 0x2b7e5cff
      case .SColor: return 0xff5656ff
      case .SettingSeparatorColor: return 0xccccccff
      case .SettingTableCellInfoGrayColor: return 0x0000004d
      case .SettingTableCellInfoYellowColor: return 0xff9138ff
      case .SettingTableCellTitleColor: return 0x000000b3
      case .SettingTableFooterInfoColor: return 0xffffffff
      case .SignInBackground: return 0x48d299ff
      case .SignInForgotPwdBtnText: return 0x00000066
      case .SignInMainTextColor: return 0x00000080
      case .SignInNavigationBar: return 0x1dbcffff
      case .SignInPlaceholderText: return 0x00000066
      case .SignInSplitLine: return 0x00000033
      case .SignUpProtocolBtn: return 0x125faeff
      case .TextFieldTextColor: return 0x000000cc
      case .UpdateProgressViewProgressColor: return 0x48d299ff
      case .UpdateProgressViewTextColor: return 0x000000ff
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

