// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

extension UIImage {
  enum Asset: String {
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
    case LeftTableViewCellAboutIcon = "LeftTableViewCellAboutIcon"
    case PageImage1 = "pageImage1"
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

