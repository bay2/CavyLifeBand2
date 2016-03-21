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

class CustomCamera: UIViewController {
    
    let screenRect = UIScreen.mainScreen().bounds
    // MARK: Definition
    
    
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var photoView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var shotCutSwitch: UIButton!
    @IBOutlet weak var flashSwitch: UIButton!
    
    @IBOutlet weak var flashOnButton: UIButton!
    @IBOutlet weak var flashOffButton: UIButton!
    @IBOutlet weak var flashAutoButton: UIButton!
    @IBOutlet weak var falshOnImge: UIImageView!
    @IBOutlet weak var falshOffImg: UIImageView!
    @IBOutlet weak var falshAtuoImg: UIImageView!
    
    
    @IBOutlet weak var changeToPhoto: UIButton!
    @IBOutlet weak var changeToVideo: UIButton!
    @IBOutlet weak var shutterPhoto: UIButton!
    @IBOutlet weak var lastImage: UIButton!

    var isPhotoOrVideo = Bool()
    var errorLabel     = UILabel?()
    var camera         = LLSimpleCamera()
    var asset          = [ALAsset]()
    var library        = ALAssetsLibrary()
    var startX         = CGFloat()// panGestureRecognizer start Location
    var countOne       = 0
    
    // MARK:  View
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.getLastPhoto()         // show lastImage
        
        self.camera.start()         // start Camera
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        isPhotoOrVideo = true
        
        /**
        init
        
        - parameter quality:      photo quality
        - parameter position:     shot position
        - parameter videoEnabled: can video
        */
        self.camera = LLSimpleCamera(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 64, self.photoView.frame.size.width, self.photoView.frame.size.height))

        self.camera.fixOrientationAfterCapture = false
        
        // 重写LLSimpleCamera两个Block属性
        self.camera.onDeviceChange = deviceChange
        self.camera.onError = cameraError
        
        // corner lastImage image Aspect fill
        self.lastImage.layer.masksToBounds    = true
        self.lastImage.layer.cornerRadius     = lastImage.frame.size.width / 2
        self.lastImage.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        self.view.addSubview(self.headView)
        self.view.addSubview(self.bottomView)
        
        // add PanGestureRecognizer
        let pan = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.camera.view.addGestureRecognizer(pan)
    }
    
    // rewrite block setOnDeviceChange
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
    
    // rewrite block setOnError
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
            label.center = CGPointMake(screenRect.width / 2, screenRect.size.height / 2)
            self.errorLabel = label
            self.view.addSubview(self.errorLabel!)
        }
    }

    // 添加手势 左移右移来改变 isPhotoOrVideo
    func panAction(sender: UIPanGestureRecognizer){
        // 判断左移 右移
        if UIGestureRecognizerState.Began == sender.state{
        
            self.startX = self.camera.view.frame.origin.x
            
        }
        let detail: CGPoint = sender.translationInView(self.view)
        
        let endX = startX + detail.x
        
        if startX - endX < -100{
            
            self.choosePhotoAction(UIButton)
            
        }else if startX - endX > 100{
            
            self.chooseVideoAction(UIButton)
            
        }else{
            //Log.error("Error for pan")
        }
    }
    
    // MARK: 其他方法
    // 获取Video保存路径
    func applicationDocumentsDirectory() -> NSURL{
        
         return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
    }
    
    // 改变选中的FlashMode的字体颜色
    func changeColorForFlashModeButton(){
        
        self.flashOnButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.flashOffButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.flashAutoButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        if camera.flash == LLCameraFlashOn {
            self.flashOnButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }else if camera.flash == LLCameraFlashOff {
            self.flashOffButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }else{
            self.flashAutoButton.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }
    }
    
    // 显示当前FlashMode类型的图像
    func changeFlashLightSwitchImage(){
        
        self.shotCutSwitch.hidden = false
        self.flashAutoButton.hidden = true
        self.flashOffButton.hidden = true
        self.flashOnButton.hidden = true
        
        if camera.flash == LLCameraFlashOn {
            
            self.flashSwitch.setImage(self.falshOnImge.image, forState: UIControlState.Normal)
            
        }else if camera.flash == LLCameraFlashOff {
            
            self.flashSwitch.setImage(self.falshOffImg.image, forState: UIControlState.Normal)
            
        }else{
            
            self.flashSwitch.setImage(self.falshAtuoImg.image, forState: UIControlState.Normal)
        }
    }
    
    // 获取系统相册最后一张图片
    func getLastPhoto(){
        
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group: ALAssetsGroup!, stop) -> Void in
            
            if group != nil {
                let assetBlock: ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!, index: Int, stop) in
                    if result != nil{
                        
                        self.asset.append(result)
                        self.countOne++
                    }
                }
                
                group.enumerateAssetsUsingBlock(assetBlock)
                
                Log.info("assets:\(self.countOne)")
                
                let myAsset = self.asset[self.countOne - 1]
                
                let image =  UIImage(CGImage: myAsset.thumbnail().takeUnretainedValue())
                
                self.lastImage.setImage(image, forState: UIControlState.Normal)
            }
            }) { (error) -> Void in
                
                Log.error("Error:\(error)")
        }
    }

    // 开始摄影
    func startVideo(){
        Log.info("开始摄像")
        
        self.shutterPhoto.backgroundColor = UIColor.redColor()
        self.shutterPhoto.layer.masksToBounds = true
        self.shutterPhoto.layer.cornerRadius = shutterPhoto.frame.width / 2
        
        // start recording
        let outputURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("cavy").URLByAppendingPathExtension("mov")
        
        Log.info("outputURL: \(outputURL)")
        
        self.camera.startRecordingWithOutputUrl(outputURL)
        
    }
    
    // 停止摄影
    func stopVideo(){
        
        Log.info("停止录像")

        self.shutterPhoto.backgroundColor = UIColor.blackColor()
        
        self.camera.stopRecording { (camera, outputFileURL, error) -> Void in
            
            // Viedo in outputURL cache
            
            Log.info("outputFileURL: \(outputFileURL)")

            self.library.writeVideoAtPathToSavedPhotosAlbum(outputFileURL) { (assetUrl, error) -> Void in
                if error != nil {
                    Log.error("Save video fail:%@", error)
                }else {
                    //self.countOne = 0
                    self.getLastPhoto()
                    Log.info("Save video succeed.")
                }
                
            }
            
        }
        self.shutterPhoto.backgroundColor = UIColor.blackColor()
    }

    // MARK: storyboard 的 ButtonAction
    // 闪光灯状态显示 打开 关闭 自动 可选
    @IBAction func changeFalshLight(sender: AnyObject) {
        Log.info("打开选择闪光灯")
        
        if LLSimpleCamera.isRearCameraAvailable() {
            if self.shotCutSwitch.hidden == false {
                
                self.shotCutSwitch.hidden = true
                self.flashAutoButton.hidden = false
                self.flashOffButton.hidden = false
                self.flashOnButton.hidden = false
                
                self.changeColorForFlashModeButton()
                
            }else{
                
                self.changeFlashLightSwitchImage()
            }
        }
    }
    
    // 选择闪光灯模式
    @IBAction func chooseFlashMode(sender: AnyObject) {
        
        Log.info("更换闪光灯")
        
        switch sender.tag - 1000 {
        case 0:
            self.camera.updateFlashMode(LLCameraFlashOn)
        case 1:
            self.camera.updateFlashMode(LLCameraFlashOff)
        case 2:
            self.camera.updateFlashMode(LLCameraFlashAuto)
        default:
            Log.error("FlashLight Change Error")
        }
        
        self.changeFlashLightSwitchImage()

        Log.info("选择了\(self.camera.flash)")
    }
    
    // 切换摄像头方向
    @IBAction func changeShot(sender: AnyObject) {
        Log.info("切换摄像头方向")
        self.camera.togglePosition()
    }
    
    
    // 返回上一页
    @IBAction func backHome(sender: AnyObject) {
        Log.info("返回主界面")
        UIApplication.sharedApplication().idleTimerDisabled = false
    }
    
    // 照相和摄影
    @IBAction func takePhotoAndVideo(sender: AnyObject) {
        
        // isPhotoOrVideo = true 照相
        if isPhotoOrVideo {
            Log.info("照相")
            self.camera.capture { (camera, image, metadata, error) -> Void in
                if error != nil{
                    return
                }
            
                self.camera.start()
                self.lastImage.setImage(image, forState: UIControlState.Normal)
                
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                
                }
        
        }else{
            // isPhotoOrVideo = false 摄影
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
        
        let storyBoard = UIStoryboard(name: "Camera", bundle: nil)
        let photoVC = storyBoard.instantiateViewControllerWithIdentifier("PhotoAlbum")
        
        self.presentViewController(photoVC, animated: true, completion: nil)
        
    }
    
    // 更改到照相模式
    @IBAction func choosePhotoAction(sender: AnyObject) {
        if self.camera.recording {
            Log.info("直接保存Video")
            self.stopVideo()
        }

        self.shutterPhoto.backgroundColor = UIColor.blackColor()
        isPhotoOrVideo = true
        
        self.changeToPhoto.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        
        self.changeToVideo.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
    }
    
    // 更改到录像模式
    @IBAction func chooseVideoAction(sender: AnyObject) {
        isPhotoOrVideo = false
        self.changeToPhoto.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.changeToVideo.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
