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
let testFile    = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F17.bin"
let testFile30  = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2H25F30.bin"
let testFile31E = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F31e.bin"
let testFile31  = "http://7xrhrs.com1.z0.glb.clouddn.com/Cavy2PR3F31e.bin"


/**
 *  菜单项 view model
 */
struct MenuViewModel: MenuProtocol {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController?
    var titleColor: UIColor
    
    
    init(icon: UIImage? = nil, title: String, titleColor: UIColor = UIColor(named: .AColor), nextView: UIViewController) {
        
        self.icon = icon
        self.title = title
        self.nextView = nextView
        self.titleColor = titleColor
        
    }
    
}

struct UpdateFWViewModel: MenuProtocol, FirmwareDownload {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController? = nil
    var filePath: String = ""
    var titleColor: UIColor = UIColor.whiteColor()

    
    init(icon: UIImage? = nil, title: String, titleColor: UIColor) {
        
        self.icon = icon
        self.title = title
        self.titleColor = titleColor
        
    }
    
    /**
     版本校验和下载地址获取
     */
    func onClickCell() {
        
        let requestAlert = UIAlertController(title: "", message: L10n.UpdateFirmwareCheckVersionAlertMsg.string, preferredStyle: .Alert)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(requestAlert, animated: true, completion: nil)
        
        // 获取手环版本信息
        LifeBandCtrl.shareInterface.getLifeBandInfo { bandInfo in
            
            let fwVersion = bandInfo.fwVersion
            let hwVersion = bandInfo.hwVersion
            
            let localVersion = "\(hwVersion)" + "." + "\(fwVersion)"
            
            // 获取服务器最新固件版本信息
            NetWebApi.shareApi.netGetRequest(WebApiMethod.Firmware.description, modelObject: FirmwareUpdateResponse.self, successHandler: { (data) in
                
                requestAlert.dismissVC(completion: nil)
                
                let localIsLast = localVersion.compare(data.data.version, options: .NumericSearch, range: nil, locale: nil) == .OrderedDescending
                
                guard localIsLast == false else {
                    CavyLifeBandAlertView.sharedIntance.showViewTitle(message: L10n.UpdateFirmwareIsNewVersionAlertMsg.string)
                    return
                    
                }
                
                let title = L10n.UpdateFirmwareInstallNewVersionAlertTitle.string + "（\(data.data.version)）"
                
                let versionAlert = UIAlertController(title: title, message: data.data.description, preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: L10n.AlertCancelActionTitle.string, style: .Cancel) { (action) in }
                
                let updateAction = UIAlertAction(title: L10n.AlertUpdateActionTitle.string, style: .Default) { (action) in
                    
                    // 检测电量是否足够
                    LifeBandCtrl.shareInterface.getBandElectric { electric in
                        
                        guard electric > 0.2 else {
                            
                            let electricAlert = UIAlertController(title: L10n.UpdateFirmwareLowElectricAlertTitle.string,
                                message: L10n.UpdateFirmwareLowElectricAlertMsg.string, preferredStyle: .Alert)
                            
                            let cancelAction = UIAlertAction(title: L10n.AlertReTryAfterChargeActionTitle.string, style: .Cancel) { (action) in }
                            
                            electricAlert.addAction(cancelAction)
                            
                            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(electricAlert, animated: true, completion: nil)
                            
                            return
                        }
                        
                        let updateView = UpdateProgressView.show()
                        self.downloadAndUpdateFW(data.data.url, updateView: updateView)
                        
                    }
                    
                }
                
                versionAlert.addAction(cancelAction)
                versionAlert.addAction(updateAction)
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(versionAlert, animated: true, completion: nil)

            }) { (msg) in
                
                requestAlert.dismissVC(completion: nil)
                
                CavyLifeBandAlertView.sharedIntance.showViewTitle(message: msg.msg)
                
            }
            
        }
  
    }
    
    /**
     下载并更新固件
     
     - parameter downLoadUrl: 下载地址
     */
    func downloadAndUpdateFW(downLoadUrl: String, updateView: UpdateProgressView) {
        
        // 下载服务器的固件
        self.downloadFirmware(downLoadUrl) {
            
            // 下载失败
            guard $0 != L10n.UpdateFirmwareDownloadError.string else {
                
                UpdateProgressView.hide()
                
                self.alertUpdateFail(downLoadUrl, updateView: updateView)
                
                return
                
            }
            
            // 将下载的固件传至手环进行升级
            LifeBandBle.shareInterface.updateFirmware($0) {
                
                $0.success { value in
                    
                    updateView.updateProgress(0.5 + value / 2) { progress in
                        
                        if progress != 1 {
                            return
                        }
                        
                        UpdateProgressView.hide()
                        
                    }
                }.failure({ _ in
                   
                    UpdateProgressView.hide()
                    
                    self.alertUpdateFail(downLoadUrl, updateView: updateView)
                   
                })
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
    
    // 固件升级失败的Alert提示
    func alertUpdateFail(downLoadUrl: String, updateView: UpdateProgressView) {
        
        let versionAlert = UIAlertController(title: "", message: L10n.UpdateFirmwareUpdateFailAlertMsg.string, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: L10n.AlertCancelActionTitle.string, style: .Cancel) { (action) in }
        
        let updateAction = UIAlertAction(title: L10n.AlertReUpdateActionTitle.string, style: .Default) { (action) in
            let updateView = UpdateProgressView.show()
            self.downloadAndUpdateFW(downLoadUrl, updateView: updateView)
        }
        
        versionAlert.addAction(cancelAction)
        versionAlert.addAction(updateAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(versionAlert, animated: true, completion: nil)
    }
    
}

struct UndoBindViewModel: MenuProtocol {
    
    var title: String
    var icon: UIImage?
    var nextView: UIViewController?
    var titleColor: UIColor
    
    
    init(icon: UIImage? = nil, title: String, titleColor: UIColor = UIColor.whiteColor()) {
        
        self.icon = icon
        self.title = title
        self.titleColor = titleColor
        
        let guideVC = StoryboardScene.Guide.instantiateGuideView()
        let guideVM = GuideBandBluetooth()
        
        guideVC.configView(guideVM, delegate: guideVM)
        
        self.nextView = guideVC
        
    }
    
    func onClickCell() {
        
        let alertView = UIAlertController(title: "", message: L10n.AlertReBindBandMsg.string, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: L10n.AlertCancelActionTitle.string, style: .Cancel, handler: nil)
        
        let sureAction = UIAlertAction(title: L10n.AlertSureActionTitle.string, style: .Default) { (action) in
            
            BindBandCtrl.bindScene = .Rebind
            
            LifeBandBle.shareInterface.bleDisconnect()
            
            guard let newNextView = self.nextView else { return }
            
            let userInfo = ["nextView": newNextView] as [NSObject: AnyObject]
            
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomePushView.rawValue, object: nil, userInfo: userInfo)
            NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeShowHomeView.rawValue, object: nil)
        }
        
        alertView.addAction(cancelAction)
        alertView.addAction(sureAction)
        
        UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertView, animated: true, completion: nil)
        
    }
    
}


/**
 *  手环功能菜单项  连接状态和非连接状态的切换
 */
struct BandFeatureMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = UIView()
    var sectionHeight: CGFloat = 16
    var titleColor = UIColor(named: .AColor)
    
    init(isConnect: Bool) {
            
        items.append(MenuViewModel(icon: UIImage(asset: isConnect ? .RightMenuCamera : .RightMenuAlarmClock_disable),
                title: L10n.HomeRightListTitleCamera.string, titleColor: UIColor(named: isConnect ? .AColor : .BColor),
                nextView: StoryboardScene.Camera.instantiateCustomCameraView()))
            
        items.append(MenuViewModel(icon: UIImage(asset: isConnect ? .RightMenuNotice : .RightMenuNotice_disable),
                title: L10n.HomeRightListTitleNotification.string, titleColor: UIColor(named: isConnect ? .AColor : .BColor),
                nextView: StoryboardScene.AlarmClock.instantiateRemindersSettingViewController()))
            
        items.append(MenuViewModel(icon: UIImage(asset: isConnect ? .RightMenuAlarmClock : .RightMenuAlarmClock_disable),
                title: L10n.HomeRightListTitleAlarmClock.string, titleColor: UIColor(named: isConnect ? .AColor : .BColor),
                nextView: StoryboardScene.AlarmClock.instantiateIntelligentClockViewController()))
            
        items.append(MenuViewModel(icon: UIImage(asset: isConnect ? .RightMenuSecurity : .RightMenuSecurity_disable),
                title: L10n.HomeRightListTitleSecurity.string, titleColor: UIColor(named: isConnect ? .AColor : .BColor),
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
    var titleColor = UIColor(named: .AColor)
    
    
    
    init(isConnect: Bool) {
        
        items.append(UpdateFWViewModel(title: L10n.HomeRightListTitleFirmwareUpgrade.string, titleColor: isConnect ? titleColor : UIColor(named: .BColor)))
        
    }
    
}

/**
 *  手环绑定相关菜单项
 */
struct BindingBandMenuGroupDataModel: MenuGroupDataSource {
    
    var items: [MenuProtocol] = []
    var sectionView: UIView = LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
    var sectionHeight: CGFloat = 10
    var titleColor = UIColor.whiteColor()
    
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
    var titleColor = UIColor.whiteColor()
    
    var loginUserId: String = CavyDefine.loginUserBaseInfo.loginUserInfo.loginUserId
    
    init() {
        
        let guideSet = StoryboardScene.Guide.instantiateGuideView()
        let guideViewModel = GuideGoalViewModel(viewStyle: .RightMenu)
        guideSet.configView(guideViewModel, delegate: guideViewModel)
        
        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuTarget),
            title: L10n.HomeLifeListTitleTarget.string,
            nextView: guideSet))
        
        //TODO 第一版隐藏 信息公开，好友，PK 功能模块
//        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuInformation),
//            title: L10n.HomeLifeListTitleInfoOpen.string,
//            nextView: StoryboardScene.InfoSecurity.AccountInfoSecurityVCScene.viewController()))
//        
//        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuFriend),
//            title: L10n.HomeLifeListTitleFriend.string,
//            nextView: StoryboardScene.Contacts.ContactsFriendListVCScene.viewController()))
//        
//        items.append(MenuViewModel(icon: UIImage(asset: .LeftMenuPK),
//            title: L10n.HomeLifeListTitlePK.string,
//            nextView: StoryboardScene.PK.instantiatePKListVC()))
        
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
    var sectionView: UIView = UIView() // LeftHeaderView(frame: CGRectMake(0, 0, ez.screenWidth, 10))
    var sectionHeight: CGFloat = 0 // 10
    var titleColor = UIColor.whiteColor()
    
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
