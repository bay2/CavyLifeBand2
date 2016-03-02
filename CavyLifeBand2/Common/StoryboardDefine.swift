// Generated using SwiftGen, by O.Halligon — https://github.com/AliSoftware/SwiftGen

import Foundation
import UIKit

protocol StoryboardSceneType {
  static var storyboardName: String { get }
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

protocol StoryboardSegueType: RawRepresentable { }

extension UIViewController {
  func performSegue<S: StoryboardSegueType where S.RawValue == String>(segue: S, sender: AnyObject? = nil) {
    performSegueWithIdentifier(segue.rawValue, sender: sender)
  }
}

struct StoryboardScene {
  enum Camera: String, StoryboardSceneType {
    static let storyboardName = "Camera"

    case CustomCameraViewScene = "CustomCameraView"
    static func instantiateCustomCameraView() -> CustomCamera {
      return StoryboardScene.Camera.CustomCameraViewScene.viewController() as! CustomCamera
    }

    case PhotoAlbumViewScene = "PhotoAlbumView"
    static func instantiatePhotoAlbumView() -> PhotoAlbum {
      return StoryboardScene.Camera.PhotoAlbumViewScene.viewController() as! PhotoAlbum
    }
  }
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case MainPageViewScene = "MainPageView"
    static func instantiateMainPageView() -> MainPageViewController {
      return StoryboardScene.Main.MainPageViewScene.viewController() as! MainPageViewController
    }

    case PageViewScene = "PageView"
    static func instantiatePageView() -> PageViewController {
      return StoryboardScene.Main.PageViewScene.viewController() as! PageViewController
    }

    case SignInViewScene = "SignInView"
    static func instantiateSignInView() -> SignInViewController {
      return StoryboardScene.Main.SignInViewScene.viewController() as! SignInViewController
    }

    case SignUpViewScene = "SignUpView"
    static func instantiateSignUpView() -> SignUpViewController {
      return StoryboardScene.Main.SignUpViewScene.viewController() as! SignUpViewController
    }
  }
  enum Weather: StoryboardSceneType {
    static let storyboardName = "Weather"
  }
}

struct StoryboardSegue {
}

