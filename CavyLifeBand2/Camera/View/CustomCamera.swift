//
//  CustomCamera.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/1/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import LLSimpleCamera
import AssetsLibrary
import Log
import EZSwiftExtensions
import SnapKit
import Photos

class CustomCamera: UIViewController {
    
    
    // MARK: Definition
    // 头 中间 底下 视图
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    // 闪光灯 切换前后摄像头 切换拍照 切换摄像
    @IBOutlet weak var flashSwitch: UIButton!
    @IBOutlet weak var shotCutSwitch: UIButton!
    @IBOutlet weak var changeToPhoto: UIButton!
    @IBOutlet weak var changeToVideo: UIButton!
    
    // 闪光灯的三个图片
    @IBOutlet weak var falshOnImge: UIImageView!
    @IBOutlet weak var falshOffImg: UIImageView!
    @IBOutlet weak var falshAtuoImg: UIImageView!
    
    // 录像计时 拍摄按钮 相册按钮
    @IBOutlet weak var videRecordTime: UILabel!
    @IBOutlet weak var shutterPhoto: UIButton!
    @IBOutlet weak var lastImage: UIButton!

    var isPhotoOrVideo: Bool = true // true 代表拍照
    var errorLabel     = UILabel?()
    var camera         = LLSimpleCamera()
    var library        = ALAssetsLibrary()
    var timer = NSTimer()
    var timerCount: Int = 0
    
    // MARK:  View
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        getLastPhoto()         // show lastImage
        
        camera.start()         // start Camera
        
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomCamera.photoAndVideo), name: LifeBandCtrlNotificationName.BandButtonEvenClick1.rawValue, object: nil)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
        // 更改UIStatusBar背景颜色
        let statusBarView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, 20))
        statusBarView.backgroundColor = UIColor.blackColor()
        camera.view.addSubview(statusBarView)
        
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        cameraAllViewLayout()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: false)
        
    }
    
    // 全部控件布局
    func cameraAllViewLayout() {
        
        // 初始化相机:(照片质量， 摄像头方向，是否可以录像)
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))
        self.camera.fixOrientationAfterCapture = false
        
        // 重写LLSimpleCamera两个Block属性
        self.camera.onDeviceChange = deviceChange
        self.camera.onError = cameraError
        
        // 相册按钮显示 切角
        self.lastImage.layer.masksToBounds    = true
        self.lastImage.layer.cornerRadius     = 6
        self.lastImage.imageView?.contentMode = UIViewContentMode.ScaleAspectFill

        view.addSubview(headView)
        view.addSubview(bottomView)
        
    }
    
    // 重写LLSimpleCamera 的 block -- setOnDeviceChange
    func deviceChange(camera: LLSimpleCamera?, device: AVCaptureDevice?) {
        
        Log.info("Device Changed.")
        
        if camera!.isFlashAvailable() {
            
            self.flashSwitch.hidden = false
            
            if camera?.flash == LLCameraFlashOff {
                
                self.flashSwitch.selected = false
                
            } else {
                
                self.flashSwitch.selected = true
            }
            
        }else{
            
            self.flashSwitch.hidden = true
        }
    }
    
    // 重写LLSimpleCamera 的 block -- setOnError
    func cameraError(camera: LLSimpleCamera?, error: NSError?) {
        
        Log.error("Camera error:\(error)")
        
        if error?.domain == LLSimpleCameraErrorDomain {
            return
        }
        
        if String(error?.code) == String(LLSimpleCameraErrorCodeCameraPermission) || String(error?.code) == String(LLSimpleCameraErrorCodeMicrophonePermission) {
            
            if self.errorLabel != nil{
                
                self.errorLabel!.removeFromSuperview()
            }
            
            let label = UILabel.init(frame: CGRectZero)
            label.text = "We need permission for the camera.\nPlease go to your settings."
            label.font = UIFont.init(name: "AvenirNext-DemiBold", size: 13)
            label.numberOfLines = 2
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.whiteColor()
            label.sizeToFit()
            label.center = CGPointMake(ez.screenWidth / 2, ez.screenHeight / 2)
            self.errorLabel = label
            
            
            self.view.addSubview(self.errorLabel!)
        }
    }
    
    // MARK: 其他方法
    // 获取Video保存路径
    func applicationDocumentsDirectory() -> NSURL{
        
         return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
    
    // 获取系统相册最后一张图片
    func getLastPhoto(){
        
        Log.info("系统最后一张图片")
        
        // 查看是否有访问权限
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        if status == PHAuthorizationStatus.Restricted || status == PHAuthorizationStatus.Denied {
            
            // 如果没有访问权限 再次请求打开访问权限
            Log.info("无访问权限")
            
            return
        }
 
        // 使用Photos来获取照片的时候，我们首先需要使用PHAsset和PHFetchOptions来得到PHFetchResult
        let fetchOptions = PHFetchOptions()
        let fetchResults = PHAsset.fetchAssetsWithOptions(fetchOptions)
        
        if fetchResults.countOfAssetsWithMediaType(.Image) > 0 {
            Log.info(fetchResults.count)
        }
        
        // 最后一张
        let lastAsset = fetchResults.lastObject as! PHAsset
        var returnImg = UIImage()
        PHImageManager.defaultManager().requestImageForAsset(lastAsset, targetSize: CGSizeMake(ez.screenWidth, ez.screenWidth), contentMode: .AspectFill, options: nil) {(result, info) -> Void in
            returnImg = result!
        }
                
        self.lastImage.setBackgroundImage(returnImg, forState: .Normal)
        
    }

    // 开始摄影
    func startVideo(){
        Log.info("开始摄像")
        
        self.videRecordTime.text = "00:00:00"
        
        // 开始计时器
        videoBeginRunTimer()
        
        self.flashSwitch.hidden = true
        self.changeToPhoto.hidden = true
        self.changeToVideo.hidden = true
        self.shotCutSwitch.hidden = true
        self.lastImage.hidden = true
        self.videRecordTime.hidden = false
        
        self.shutterPhoto.setImage(UIImage(asset: .CameraVideoStart), forState: .Normal)
        self.shutterPhoto.layer.masksToBounds = true
        self.shutterPhoto.layer.cornerRadius = shutterPhoto.frame.width / 2
        
        // start recording
        let outputURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("cavy").URLByAppendingPathExtension("mov")
        
        self.camera.startRecordingWithOutputUrl(outputURL) {(camera, outputFileUrl, error) in
            
            // 保存视频
            self.library.writeVideoAtPathToSavedPhotosAlbum(outputFileUrl) {(assetUrl, error) -> Void in
                if error != nil {
                    Log.error("Save video fail:%@", error)
                } else {
                    //self.countOne = 0
                    Log.info("Save video succeed.")
                    self.getLastPhoto()
                }
                
            }
            
        }
        
    }
    
    // 停止摄影
    func stopVideo(){
        
        Log.info("停止录像")
        
        self.camera.recording = false
        
        // 停止计时器 时间归零
        timer.invalidate()
        timerCount = 0
        
        self.flashSwitch.hidden = false
        self.shotCutSwitch.hidden = false
        self.changeToPhoto.hidden = false
        self.changeToVideo.hidden = false
        self.lastImage.hidden = false
        self.videRecordTime.hidden = true
        
        self.shutterPhoto.setImage(UIImage(asset: .CameraVideoWait), forState: .Normal)
        
        // 保存录像
        self.camera.stopRecording()
        
    }

    // 取消录像
    func stopVideoNoSave() {
        
        Log.info("取消录像")
        
        // 停止计时器 时间归零
        timer.invalidate()
        timerCount = 0
        
        self.flashSwitch.hidden = false
        self.shotCutSwitch.hidden = false
        self.changeToPhoto.hidden = false
        self.changeToVideo.hidden = false
        self.lastImage.hidden = false
        self.videRecordTime.hidden = true
        
        self.shutterPhoto.setImage(UIImage(asset: .CameraVideoWait), forState: .Normal)
        // 保存录像
        self.camera.stopRecording()

    }
    
    // 录像计时器 开始计时
    func videoBeginRunTimer() {
        
        Log.info("录像开始计时")
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(CustomCamera.timerRun(_:)), userInfo: nil, repeats: true)
        
    }
    
    func timerRun(timer: NSTimer) {
        
        timerCount += 1
        Log.info(timerCount)
        

        let hour    = timerCount / 3600
        let minutes = timerCount / 60
        let second  = timerCount - hour * 3600 - minutes * 60
        
        if hour < 10 && minutes < 10 && second < 10 {
            
            self.videRecordTime.text = "0\(hour):0\(minutes):0\(second)"
            
        } else if hour < 10 && minutes < 10 {
            
            self.videRecordTime.text = "0\(hour):0\(minutes):\(second)"
            
        } else if hour < 10 {
            
            self.videRecordTime.text = "0\(hour):\(minutes):\(second)"
            
        } else {
            
            self.videRecordTime.text = "\(hour):\(minutes):\(second)"
        }
        
    }
    
    
    // MARK: storyboard 的 ButtonAction
    // 闪光灯状态显示 打开 关闭 自动 可选
    @IBAction func changeFalshLight(sender: AnyObject) {
        Log.info("更换闪光灯")
        
        if camera.flash == LLCameraFlashOn {
            
            self.camera.updateFlashMode(LLCameraFlashOff)
            self.flashSwitch.setImage(self.falshOffImg.image, forState: UIControlState.Normal)
            
        } else if camera.flash == LLCameraFlashOff {
            self.camera.updateFlashMode(LLCameraFlashAuto)
            self.flashSwitch.setImage(self.falshAtuoImg.image, forState: UIControlState.Normal)
            
        } else if camera.flash == LLCameraFlashAuto {
            self.camera.updateFlashMode(LLCameraFlashOn)
            self.flashSwitch.setImage(self.falshOnImge.image, forState: UIControlState.Normal)
        }

    }
    
    // 切换摄像头方向
    @IBAction func changeShot(sender: AnyObject) {
        Log.info("切换摄像头方向")
        self.camera.togglePosition()
    }
    
    
    // 返回上一页
    @IBAction func backHome(sender: AnyObject) {
        
        UIApplication.sharedApplication().idleTimerDisabled = false
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.popViewControllerAnimated(false)
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeRightOnClickMenu.rawValue, object: nil)
        stopVideoNoSave()
        
    }
    
    // 照相和摄影
    @IBAction func takePhotoAndVideo(sender: AnyObject) {
        photoAndVideo()
    }
    
    /**
     照相或摄影
     
     - author: sim cai
     - date: 2016-05-31
     */
    func photoAndVideo() {
        
        if isPhotoOrVideo {
            
            Log.info("照相")
            
            self.camera.capture ({(camera, image, metadata, error) -> Void in
                if error != nil{
                    return
                }
                
                self.camera.start()
                self.lastImage.setImage(image, forState: UIControlState.Normal)
                
                let newimage: UIImage = image.imageRotateNormal()
                
                UIImageWriteToSavedPhotosAlbum(newimage, nil, nil, nil)

            }, exactSeenImage: true)
            
        }else{

            if self.camera.recording == false {
                
                // start recording
                self.startVideo()
                
            }else{
                
                // stop recording
                self.stopVideo()
            }
        }
        
    }
    
    // 打开相册
    @IBAction func goPhotoAlbum(sender: AnyObject) {
        
        // 使用Photos来获取照片的时候，我们首先需要使用PHAsset和PHFetchOptions来得到PHFetchResult
        let fetchOptions = PHFetchOptions()        
        let fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        let photoVC = StoryboardScene.Camera.instantiatePhotoAlbumView()

        photoVC.totalCount = fetchResults.count
        photoVC.currentCount = fetchResults.count
        photoVC.loadIndex = fetchResults.count - 10
        
        self.presentVC(photoVC)

    }
    
    // 更改到照相模式
    @IBAction func choosePhotoAction(sender: AnyObject) {
        
        isPhotoOrVideo = true
        self.shutterPhoto.setImage(UIImage(asset: .CameraTakePhoto), forState: .Normal)
        
        self.changeToPhoto.setTitleColor(UIColor(named: .CameraChoose), forState: UIControlState.Normal)
        
        self.changeToVideo.setTitleColor(UIColor(named: .CameraNoChoose), forState: UIControlState.Normal)
        
    }
    
    // 更改到录像模式
    @IBAction func chooseVideoAction(sender: AnyObject) {
        isPhotoOrVideo = false
        self.shutterPhoto.setImage(UIImage(asset: .CameraVideoWait), forState: .Normal)
        self.changeToPhoto.setTitleColor(UIColor(named: .CameraNoChoose), forState: UIControlState.Normal)
        self.changeToVideo.setTitleColor(UIColor(named: .CameraChoose), forState: UIControlState.Normal)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 }
