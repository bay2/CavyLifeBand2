// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

extension UIImage {
  enum Asset : String {
    case Backbtn = "backbtn"
    case Camera = "camera"
    case Camera_cutover = "camera_cutover"
    case Cancel = "cancel"
    case Chosenbtn = "chosenbtn"
    case Flash_automatic = "flash_automatic"
    case Flash_off = "flash_off"
    case Flash_on = "flash_on"
    case PageImage1 = "pageImage1"
    case Photograph = "photograph"
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

