// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

protocol StoryboardSceneType {
  static var storyboardName : String { get }
}

extension StoryboardSceneType {
  static func storyboard() -> UIStoryboard {
    return UIStoryboard(name: self.storyboardName, bundle: nil)
  }

  static func initialViewController() -> UIViewController {
    return storyboard().instantiateInitialViewController()!
  }
}

extension StoryboardSceneType where Self: RawRepresentable, Self.RawValue == String {
  func viewController() -> UIViewController {
    return Self.storyboard().instantiateViewControllerWithIdentifier(self.rawValue)
  }
  static func viewController(identifier: Self) -> UIViewController {
    return identifier.viewController()
  }
}

protocol StoryboardSegueType : RawRepresentable { }

extension UIViewController {
  func performSegue<S : StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum Camera : String, StoryboardSceneType {
    static let storyboardName = "Camera"

    case CustomCameraView = "CustomCameraView"
    static func customCameraViewViewController() -> CustomCamera {
      return StoryboardScene.Camera.CustomCameraView.viewController() as! CustomCamera
    }

    case PhotoAlbumView = "PhotoAlbumView"
    static func photoAlbumViewViewController() -> PhotoAlbum {
      return StoryboardScene.Camera.PhotoAlbumView.viewController() as! PhotoAlbum
    }
  }
  enum LaunchScreen : StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main : String, StoryboardSceneType {
    static let storyboardName = "Main"

    case MainPageView = "MainPageView"
    static func mainPageViewViewController() -> PageViewController {
      return StoryboardScene.Main.MainPageView.viewController() as! PageViewController
    }

    case SignInView = "SignInView"
    static func signInViewViewController() -> SignInViewController {
      return StoryboardScene.Main.SignInView.viewController() as! SignInViewController
    }
  }
  enum Weather : StoryboardSceneType {
    static let storyboardName = "Weather"
  }
}

struct StoryboardSegue {
}

