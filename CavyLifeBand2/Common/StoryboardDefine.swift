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
<<<<<<< HEAD
    static func instantiateCustomCameraView() -> CustomCamera {
=======
    static func instanciateCustomCameraView() -> CustomCamera {
>>>>>>> bay2/master
      return StoryboardScene.Camera.CustomCameraViewScene.viewController() as! CustomCamera
    }

    case PhotoAlbumViewScene = "PhotoAlbumView"
<<<<<<< HEAD
    static func instantiatePhotoAlbumView() -> PhotoAlbum {
      return StoryboardScene.Camera.PhotoAlbumViewScene.viewController() as! PhotoAlbum
    }
  }
  enum Guide: String, StoryboardSceneType {
    static let storyboardName = "Guide"

    case GuideViewScene = "GuideView"
    static func instantiateGuideView() -> GuideViewController {
      return StoryboardScene.Guide.GuideViewScene.viewController() as! GuideViewController
    }
  }
=======
    static func instanciatePhotoAlbumView() -> PhotoAlbum {
      return StoryboardScene.Camera.PhotoAlbumViewScene.viewController() as! PhotoAlbum
    }
  }
>>>>>>> bay2/master
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case MainPageViewScene = "MainPageView"
<<<<<<< HEAD
    static func instantiateMainPageView() -> MainPageViewController {
=======
    static func instanciateMainPageView() -> MainPageViewController {
>>>>>>> bay2/master
      return StoryboardScene.Main.MainPageViewScene.viewController() as! MainPageViewController
    }

    case PageViewScene = "PageView"
<<<<<<< HEAD
    static func instantiatePageView() -> PageViewController {
=======
    static func instanciatePageView() -> PageViewController {
>>>>>>> bay2/master
      return StoryboardScene.Main.PageViewScene.viewController() as! PageViewController
    }

    case SignInViewScene = "SignInView"
<<<<<<< HEAD
    static func instantiateSignInView() -> SignInViewController {
=======
    static func instanciateSignInView() -> SignInViewController {
>>>>>>> bay2/master
      return StoryboardScene.Main.SignInViewScene.viewController() as! SignInViewController
    }

    case SignUpViewScene = "SignUpView"
<<<<<<< HEAD
    static func instantiateSignUpView() -> SignUpViewController {
=======
    static func instanciateSignUpView() -> SignUpViewController {
>>>>>>> bay2/master
      return StoryboardScene.Main.SignUpViewScene.viewController() as! SignUpViewController
    }
  }
  enum Weather: StoryboardSceneType {
    static let storyboardName = "Weather"
  }
}

struct StoryboardSegue {
}

