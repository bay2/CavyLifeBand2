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
  enum AccountInfo: String, StoryboardSceneType {
    static let storyboardName = "AccountInfo"

    case ContactsAccountInfoVCScene = "ContactsAccountInfoVC"
    static func instantiateContactsAccountInfoVC() -> ContactsAccountInfoVC {
      return StoryboardScene.AccountInfo.ContactsAccountInfoVCScene.viewController() as! ContactsAccountInfoVC
    }
  }
  enum AlarmClock: String, StoryboardSceneType {
    static let storyboardName = "AlarmClock"

    case AddClockViewControllerScene = "AddClockViewController"
    static func instantiateAddClockViewController() -> AddClockViewController {
      return StoryboardScene.AlarmClock.AddClockViewControllerScene.viewController() as! AddClockViewController
    }

    case IntelligentClockViewControllerScene = "IntelligentClockViewController"
    static func instantiateIntelligentClockViewController() -> IntelligentClockViewController {
      return StoryboardScene.AlarmClock.IntelligentClockViewControllerScene.viewController() as! IntelligentClockViewController
    }

    case RemindersSettingViewControllerScene = "RemindersSettingViewController"
    static func instantiateRemindersSettingViewController() -> RemindersSettingViewController {
      return StoryboardScene.AlarmClock.RemindersSettingViewControllerScene.viewController() as! RemindersSettingViewController
    }

    case SafetySettingViewControllerScene = "SafetySettingViewController"
    static func instantiateSafetySettingViewController() -> SafetySettingViewController {
      return StoryboardScene.AlarmClock.SafetySettingViewControllerScene.viewController() as! SafetySettingViewController
    }
  }
  enum Camera: String, StoryboardSceneType {
    static let storyboardName = "Camera"

    case CustomCameraViewScene = "CustomCameraView"
    static func instantiateCustomCameraView() -> CustomCamera {
      return StoryboardScene.Camera.CustomCameraViewScene.viewController() as! CustomCamera
    }

    case PhotoViewScene = "PhotoView"
    static func instantiatePhotoView() -> PhotoView {
      return StoryboardScene.Camera.PhotoViewScene.viewController() as! PhotoView
    }
  }
  enum Contacts: String, StoryboardSceneType {
    static let storyboardName = "Contacts"

    case ContactsAddFriendVCScene = "ContactsAddFriendVC"
    static func instantiateContactsAddFriendVC() -> ContactsAddFriendVC {
      return StoryboardScene.Contacts.ContactsAddFriendVCScene.viewController() as! ContactsAddFriendVC
    }

    case ContactsFriendInfoVCScene = "ContactsFriendInfoVC"
    static func instantiateContactsFriendInfoVC() -> ContactsFriendInfoVC {
      return StoryboardScene.Contacts.ContactsFriendInfoVCScene.viewController() as! ContactsFriendInfoVC
    }

    case ContactsFriendListVCScene = "ContactsFriendListVC"
    static func instantiateContactsFriendListVC() -> ContactsFriendListVC {
      return StoryboardScene.Contacts.ContactsFriendListVCScene.viewController() as! ContactsFriendListVC
    }

    case ContactsNewFriendVCScene = "ContactsNewFriendVC"
    static func instantiateContactsNewFriendVC() -> ContactsNewFriendVC {
      return StoryboardScene.Contacts.ContactsNewFriendVCScene.viewController() as! ContactsNewFriendVC
    }

    case ContactsPersonInfoVCScene = "ContactsPersonInfoVC"
    static func instantiateContactsPersonInfoVC() -> ContactsPersonInfoVC {
      return StoryboardScene.Contacts.ContactsPersonInfoVCScene.viewController() as! ContactsPersonInfoVC
    }

    case ContactsReqFriendVCScene = "ContactsReqFriendVC"
    static func instantiateContactsReqFriendVC() -> ContactsReqFriendVC {
      return StoryboardScene.Contacts.ContactsReqFriendVCScene.viewController() as! ContactsReqFriendVC
    }

    case SearchResultViewScene = "SearchResultView"
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
    static func instantiateLeftView() -> LeftMenViewController {
      return StoryboardScene.Home.LeftViewScene.viewController() as! LeftMenViewController
    }

    case RightViewScene = "RightView"
    static func instantiateRightView() -> RightViewController {
      return StoryboardScene.Home.RightViewScene.viewController() as! RightViewController
    }

    case RootViewScene = "RootView"
    static func instantiateRootView() -> RootViewController {
      return StoryboardScene.Home.RootViewScene.viewController() as! RootViewController
    }
  }
  enum InfoSecurity: String, StoryboardSceneType {
    static let storyboardName = "InfoSecurity"

    case AccountInfoSecurityVCScene = "AccountInfoSecurityVC"
    static func instantiateAccountInfoSecurityVC() -> AccountInfoSecurityVC {
      return StoryboardScene.InfoSecurity.AccountInfoSecurityVCScene.viewController() as! AccountInfoSecurityVC
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

    case SignInViewScene = "SignInView"
    static func instantiateSignInView() -> SignInViewController {
      return StoryboardScene.Main.SignInViewScene.viewController() as! SignInViewController
    }
  }
  enum PK: String, StoryboardSceneType {
    static let storyboardName = "PK"

    case PKIntroduceVCScene = "PKIntroduceVC"
    static func instantiatePKIntroduceVC() -> PKIntroduceVC {
      return StoryboardScene.PK.PKIntroduceVCScene.viewController() as! PKIntroduceVC
    }

    case PKInvitationVCScene = "PKInvitationVC"
    static func instantiatePKInvitationVC() -> PKInvitationVC {
      return StoryboardScene.PK.PKInvitationVCScene.viewController() as! PKInvitationVC
    }

    case PKListVCScene = "PKListVC"
    static func instantiatePKListVC() -> PKListVC {
      return StoryboardScene.PK.PKListVCScene.viewController() as! PKListVC
    }

    case PKRulesVCScene = "PKRulesVC"
    static func instantiatePKRulesVC() -> PKRulesVC {
      return StoryboardScene.PK.PKRulesVCScene.viewController() as! PKRulesVC
    }

    case PKSelectOppTVCScene = "PKSelectOppTVC"
    static func instantiatePKSelectOppTVC() -> PKSelectOppTVC {
      return StoryboardScene.PK.PKSelectOppTVCScene.viewController() as! PKSelectOppTVC
    }
  }
  enum Relate: String, StoryboardSceneType {
    static let storyboardName = "Relate"

    case AboutVCScene = "AboutVC"
    static func instantiateAboutVC() -> AboutVC {
      return StoryboardScene.Relate.AboutVCScene.viewController() as! AboutVC
    }

    case FunctionIntroduceVCScene = "FunctionIntroduceVC"
    static func instantiateFunctionIntroduceVC() -> FunctionIntroduceVC {
      return StoryboardScene.Relate.FunctionIntroduceVCScene.viewController() as! FunctionIntroduceVC
    }

    case HelpAndFeedbackListVCScene = "HelpAndFeedbackListVC"
    static func instantiateHelpAndFeedbackListVC() -> HelpAndFeedbackListVC {
      return StoryboardScene.Relate.HelpAndFeedbackListVCScene.viewController() as! HelpAndFeedbackListVC
    }

    case HelpAndFeedbackVCScene = "HelpAndFeedbackVC"
    static func instantiateHelpAndFeedbackVC() -> HelpAndFeedbackVC {
      return StoryboardScene.Relate.HelpAndFeedbackVCScene.viewController() as! HelpAndFeedbackVC
    }

    case RelateAppVCScene = "RelateAppVC"
    static func instantiateRelateAppVC() -> RelateAppVC {
      return StoryboardScene.Relate.RelateAppVCScene.viewController() as! RelateAppVC
    }
  }
}

struct StoryboardSegue {
}

