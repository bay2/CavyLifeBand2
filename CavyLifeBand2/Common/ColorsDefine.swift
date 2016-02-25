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
    /// Alpha: 0% <br/> (0xffffff00)
    case MainPageBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case MainPageBtnText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
    /// Alpha: 100% <br/> (0xffffffff)
    case MainPageSelectedBtn
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#42cd59"></span>
    /// Alpha: 100% <br/> (0x42cd59ff)
    case MainPageSelectedBtnText
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1cd2ff"></span>
    /// Alpha: 100% <br/> (0x1cd2ffff)
    case SignInBackground
    /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#009fe2"></span>
    /// Alpha: 100% <br/> (0x009fe2ff)
    case SignInTextFieldViewBackground

    var rgbaValue: UInt32! {
      switch self {
      case .MainPageBtn: return 0xffffff00
      case .MainPageBtnText: return 0xffffffff
      case .MainPageSelectedBtn: return 0xffffffff
      case .MainPageSelectedBtnText: return 0x42cd59ff
      case .SignInBackground: return 0x1cd2ffff
      case .SignInTextFieldViewBackground: return 0x009fe2ff
      }
    }
  }

  convenience init(named name: Name) {
    self.init(rgbaValue: name.rgbaValue)
  }
}

