// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import UIKit

extension UIImage {
  enum Asset: String {
    case AlarmClockAdd = "AlarmClockAdd"
    case AlarmClockNavSave = "AlarmClockNavSave"
    case Backbtn = "backbtn"
    case CameraFlashAuto = "CameraFlashAuto"
    case CameraFlashClosed = "CameraFlashClosed"
    case CameraFlashOpen = "CameraFlashOpen"
    case CameraTakePhoto = "CameraTakePhoto"
    case CameraTurnCamera = "CameraTurnCamera"
    case CameraVideoShot = "CameraVideoShot"
    case CameraVideoStart = "CameraVideoStart"
    case CamerVideoWait = "CamerVideoWait"
    case Chosenbtn = "chosenbtn"
    case ContactsAccountEditButton = "ContactsAccountEditButton"
    case ContactsAddrssBookNormal = "ContactsAddrssBookNormal"
    case ContactsAddrssBookSelected = "ContactsAddrssBookSelected"
    case ContactsCare = "ContactsCare"
    case ContactsListAdd = "ContactsListAdd"
    case ContactsListCavy = "ContactsListCavy"
    case ContactsListNew = "ContactsListNew"
    case ContactsNearbyNormal = "ContactsNearbyNormal"
    case ContactsNearbySelected = "ContactsNearbySelected"
    case ContactsRecommendNormal = "ContactsRecommendNormal"
    case ContactsRecommendSelected = "ContactsRecommendSelected"
    case GuideBluetooth = "GuideBluetooth"
    case GuideFlagH = "GuideFlagH"
    case GuideFlagV = "GuideFlagV"
    case GuideGenderBoyChosen = "GuideGenderBoyChosen"
    case GuideGenderBoyGary = "GuideGenderBoyGary"
    case GuideGenderGirlChosen = "GuideGenderGirlChosen"
    case GuideGenderGirlGary = "GuideGenderGirlGary"
    case GuideLocation = "GuideLocation"
    case GuideNotice = "GuideNotice"
    case GuideOpenBand = "GuideOpenBand"
    case GuidePairFail = "GuidePairFail"
    case GuidePairSeccuss = "GuidePairSeccuss"
    case GuideRightBtn = "GuideRightBtn"
    case GuideRightBtnPressed = "GuideRightBtnPressed"
    case GuideWeightBg = "GuideWeightBg"
    case GuideWeightNiddle = "GuideWeightNiddle"
    case GuigeFlashBtn = "GuigeFlashBtn"
    case GuigeFlashBtnPressed = "GuigeFlashBtnPressed"
    case LeftMenuAbout = "LeftMenuAbout"
    case LeftMenuApp = "LeftMenuApp"
    case LeftMenuFriend = "LeftMenuFriend"
    case LeftMenuHelp = "LeftMenuHelp"
    case LeftMenuInformation = "LeftMenuInformation"
    case LeftMenuPK = "LeftMenuPK"
    case LeftMenuTarget = "LeftMenuTarget"
    case PageImage1 = "pageImage1"
    case PersonalInfoEdit = "PersonalInfoEdit"
    case PersonalInfoFemale = "PersonalInfoFemale"
    case PersonalInfoHonorLighted = "PersonalInfoHonorLighted"
    case PersonalInfoHonorNormal = "PersonalInfoHonorNormal"
    case PersonalInfoMale = "PersonalInfoMale"
    case Splash = "splash"
    case Unchosenbtn = "unchosenbtn"

    var image: UIImage {
      return UIImage(asset: self)
    }
  }

  convenience init!(asset: Asset) {
    self.init(named: asset.rawValue)
  }
}

