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
  enum Contacts: String, StoryboardSceneType {
    static let storyboardName = "Contacts"

    case ContactsFriendInfoVCScene = "ContactsFriendInfoVC"
    static func instantiateContactsFriendInfoVC() -> ContactsFriendInfoVC {
      return StoryboardScene.Contacts.ContactsFriendInfoVCScene.viewController() as! ContactsFriendInfoVC
    }

    case ContactsNewFriendScene = "ContactsNewFriend"
    static func instantiateContactsNewFriend() -> ContactsNewFriendVC {
      return StoryboardScene.Contacts.ContactsNewFriendScene.viewController() as! ContactsNewFriendVC
    }

    case ContactsPersonInfoVCScene = "ContactsPersonInfoVC"
    static func instantiateContactsPersonInfoVC() -> ContactsPersonInfoVC {
      return StoryboardScene.Contacts.ContactsPersonInfoVCScene.viewController() as! ContactsPersonInfoVC
    }

    case ContactsViewScene = "ContactsView"
    static func instantiateContactsView() -> ContactsViewController {
      return StoryboardScene.Contacts.ContactsViewScene.viewController() as! ContactsViewController
    }

    case RquestViewScene = "RquestView"
    static func instantiateRquestView() -> RequestViewController {
      return StoryboardScene.Contacts.RquestViewScene.viewController() as! RequestViewController
    }

    case SearchViewScene = "SearchView"
    static func instantiateSearchView() -> ContactsSearchVC {
      return StoryboardScene.Contacts.SearchViewScene.viewController() as! ContactsSearchVC
    }

    case SearchResultViewScene = "searchResultView"
    static func instantiateSearchResultView() -> UITableViewController {
      return StoryboardScene.Contacts.SearchResultViewScene.viewController() as! UITableViewController
    }
  }
  enum Guide: String, StoryboardSceneType {
    static let storyboardName = "Guide"

    case GuideViewScene = "GuideView"
    static func instantiateGuideView() -> GuideViewController {
      return StoryboardScene.Guide.GuideViewScene.viewController() as! GuideViewController
    }
  }
  enum Home: String, StoryboardSceneType {
    static let storyboardName = "Home"

    case HomeViewScene = "HomeView"
    static func instantiateHomeView() -> HomeViewController {
      return StoryboardScene.Home.HomeViewScene.viewController() as! HomeViewController
    }

    case LeftViewScene = "LeftView"
    static func instantiateLeftView() -> LeftViewController {
      return StoryboardScene.Home.LeftViewScene.viewController() as! LeftViewController
    }

    case RootViewScene = "RootView"
    static func instantiateRootView() -> RootViewController {
      return StoryboardScene.Home.RootViewScene.viewController() as! RootViewController
    }
  }
  enum LaunchScreen: StoryboardSceneType {
    static let storyboardName = "LaunchScreen"
  }
  enum Main: String, StoryboardSceneType {
    static let storyboardName = "Main"

    case AccountManagerViewScene = "AccountManagerView"
    static func instantiateAccountManagerView() -> AccountManagerViewController {
      return StoryboardScene.Main.AccountManagerViewScene.viewController() as! AccountManagerViewController
    }

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
  }
  enum Weather: StoryboardSceneType {
    static let storyboardName = "Weather"
  }
}

struct StoryboardSegue {
}

