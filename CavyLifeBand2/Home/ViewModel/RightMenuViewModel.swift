//
//  RightMenuViewModel.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/21.
//  Copyright © 2016年 xuemincai. All rights reserved.
//
import UIKit
import EZSwiftExtensions
import RealmSwift
import JSONJoy


//TODO: 固件升级测试数据
let testFile = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F17.bin"
let testFile30 = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2H25F30.bin"
let testFile31E = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F31e.bin"
let testFile31 = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F31e.bin"

/**
 *  菜单项 view model
 */
struct MenuViewModel: MenuProtocol {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController?
    
    init(icon: UIImage? = nil, title: String, nextView: UIViewController) {
        
        self.icon = icon
        self.title = title
        self.nextView = nextView
        
    }
    
}

struct UpdateFWViewModel: MenuProtocol, FirmwareDownload {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController? = nil
    var filePath: String = ""
    
    init(icon: UIImage? = nil, title: String) {
        
        self.icon = icon
        self.title = title

        
    }
    
    func onClickCell() {
        
        // 如果手环没连接，return
        if LifeBandBle.shareInterface.getConnectState() != .Connected {
            CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.UpdateFirmwareBandDisconnectAlertMsg.string)
            return
        }
        
        let updateView = UpdateProgressView.show()
        
        //TODO: 固件升级，等服务器接口完成，这边补充版本校验和下载地址获取
        self.downloadFirmware(testFile31) {
            
                LifeBandBle.shareInterface.updateFirmware($0) {
                    
                    $0.success { value in
                        
                        updateView.updateProgress(0.5 + value / 2) { progress in
                            
                            if progress != 1 {
                                return
                            }
                            
                            UpdateProgressView.hide()
                            
                        }
                    }
                }
            
            }.progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            
            var percentage = (Double(totalBytesRead) / Double(totalBytesExpectedToRead)) * 100
            
            percentage = percentage == 100 ? 99 : percentage
            
            Log.info("percentage = \(percentage)")
            
            ez.runThisInMainThread {
                
                updateView.updateProgress(percentage / 100 / 2)
                
            }
            
        }
        
    }
    
}

struct UndoBindViewModel: MenuProtocol {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController?
    
    init(icon: UIImage? = nil, title: String) {
        
        self.icon = icon
        self.title = title
        
        let guideVC = StoryboardScene.Guide.instantiateGuideView()
        let guideVM = GuideBandBluetooth()
        
        guideVC.configView(guideVM, delegate: guideVM)
        
        self.nextView = guideVC
        
    }
    
    func onClickCell() {
        
        BindBandCtrl.bindScene = .Rebind
        
        LifeBandBle.shareInterface.bleDisconnect()
        
        guard let newNextView = nextView else {
            return
        }
        
        let userInfo = ["nextView": newNextView] as [NSObject: AnyObject]
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)
        
    }
    
}


/**
 *  手环功能菜单项
 */
struct BandFeatureMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = UIView()
    var sectionHeight: CGFloat = 16
    
    init() {
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuCamera),
            title: L10n.HomeRightListTitleCamera.string,
            nextView: StoryboardScene.Camera.instantiateCustomCameraView()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuNotice),
            title: L10n.HomeRightListTitleNotification.string,
            nextView: StoryboardScene.AlarmClock.instantiateRemindersSettingViewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuAlarmClock),
            title: L10n.HomeRightListTitleAlarmClock.string,
            nextView: StoryboardScene.AlarmClock.instantiateIntelligentClockViewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .RightMenuSecurity),
            title: L10n.HomeRightListTitleSecurity.string,
            nextView: StoryboardScene.AlarmClock.instantiateSafetySettingViewController()))
        
    }
    
}

/**
 *  手环硬件相关菜单项
 */
struct BandHardwareMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    
    init() {
        
        items.append(UpdateFWViewModel(title: L10n.HomeRightListTitleFirmwareUpgrade.string))
        
    }
    
}

/**
 *  手环绑定相关菜单项
 */
struct BindingBandMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    
    init() {
        
        items.append(UndoBindViewModel(title: L10n.HomeRightListTitleBindingBand.string))
        
    }
    
}

/**
 *  APP功能菜单
 */
struct AppFeatureMenuGroupDataModel: MenuGroupDataSource, PKRecordsRealmModelOperateDelegate {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = UIView()
    var sectionHeight: CGFloat = 16
    var realm: Realm = try! Realm()
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    init() {
        
        let guideSet = StoryboardScene.Guide.instantiateGuideView()
        let guideViewModel = GuideGoalViewModel(viewStyle: .RightMenu)
        guideSet.configView(guideViewModel, delegate: guideViewModel)
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuTarget),
            title: L10n.HomeLifeListTitleTarget.string,
            nextView: guideSet))
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuInformation),
            title: L10n.HomeLifeListTitleInfoOpen.string,
            nextView: StoryboardScene.InfoSecurity.AccountInfoSecurityVCScene.viewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuFriend),
            title: L10n.HomeLifeListTitleFriend.string,
            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuPK),
            title: L10n.HomeLifeListTitlePK.string,
            nextView: StoryboardScene.PK.instantiatePKListVC()))
        
    }
    
    /**
     刷新下个访问的视图
     */
    mutating func refurbishNextView() {
        
        items = items.map { (item) -> MenuProtocol in
            
            if item.title == L10n.HomeLifeListTitlePK.string {
                
                var newItem = item
                
                if queryPKWaitRecordsRealm().count > 0 || queryPKDueRecordsRealm().count > 0 || queryPKFinishRecordsRealm().count > 0 {
                    newItem.nextView = StoryboardScene.PK.instantiatePKListVC()
                } else {
                    newItem.nextView = StoryboardScene.PK.instantiatePKIntroduceVC()
                }
                
                return newItem
            }
            
            return item
            
        }
        
    }
    
}

/**
 *  APP 关于菜单组
 */
struct AppAboutMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    
    init() {
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuAbout),
            title: L10n.HomeLifeListTitleAbout.string,
            nextView: StoryboardScene.Relate.instantiateAboutVC()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuHelp),
            title: L10n.HomeLifeListTitleHelp.string,
            nextView: StoryboardScene.Relate.instantiateHelpAndFeedbackListVC()))
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuApp),
            title: L10n.HomeLifeListTitleRelated.string,
            nextView: StoryboardScene.Relate.instantiateRelateAppVC()))
        
        
    }
    
}
