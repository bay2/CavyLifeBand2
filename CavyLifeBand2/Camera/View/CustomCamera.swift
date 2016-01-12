//
//  CustomCamera.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/1/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import LLSimpleCamera

class CustomCamera: UIViewController {
    
    let screenRect = UIScreen.mainScreen().bounds
    // MARK: Definition
    @IBOutlet weak var headView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var shotCutSwitch: UIButton!
    @IBOutlet weak var flashSwitch: UIButton!
    
    @IBOutlet weak var btn4FlashOn: UIButton!
    @IBOutlet weak var btn4FlashOff: UIButton!
    @IBOutlet weak var btn4FlashAuto: UIButton!
    @IBOutlet weak var img4FalshAtuo: UIImageView!
    @IBOutlet weak var img4FalshOn: UIImageView!
    @IBOutlet weak var img4FalshOff: UIImageView!
    
    
    @IBOutlet weak var photoView: UIView!
    var camera = LLSimpleCamera()
    var errorLabel:UILabel?
    
    var isPhotoOrVideo = Bool()
    
    @IBOutlet weak var btn4ChangeToPhoto: UIButton!
    @IBOutlet weak var btn4ChangeToVideo: UIButton!
    @IBOutlet weak var shutterPhoto: UIButton!
    @IBOutlet weak var lastImage: UIButton!

    var startX = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        
        isPhotoOrVideo = true // true 表示照相 false 表示录像
        
        /**
        init
        
        - parameter quality:      photo quality
        - parameter position:     shot position
        - parameter videoEnabled: can video
        */
        self.camera = LLSimpleCamera.init(quality: AVCaptureSessionPresetHigh, position: LLCameraPositionRear, videoEnabled: true)
        
        self.camera.attachToViewController(self, withFrame: CGRectMake(0, 64, self.photoView.frame.size.width, self.photoView.frame.size.height))

        self.camera.fixOrientationAfterCapture = false
        
        self.camera.onDeviceChange = deviceChange
        
        self.camera.onError = cameraError
        
        // corner lastImage image Aspect fill
        self.lastImage.layer.masksToBounds = true
        self.lastImage.layer.cornerRadius = lastImage.frame.size.width / 2
        self.lastImage.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
    
        self.view.addSubview(self.headView)
        self.view.addSubview(self.bottomView)
        
        // add PanGestureRecognizer
        let pan = UIPanGestureRecognizer(target: self, action: "panAction:")
        self.camera.view.addGestureRecognizer(pan)
        
    }
        // Block setOnDeviceChange
    func deviceChange(camera: LLSimpleCamera?, device: AVCaptureDevice?) {
        print("Device Changed.")
        
        if camera!.isFlashAvailable() {
            
            self.flashSwitch.hidden = false
            
            if(camera?.flash == LLCameraFlashOff){
                
                self.flashSwitch.selected = false
                
            }else{
                
                self.flashSwitch.selected = true
                
            }
            
        }else{
            
            self.flashSwitch.hidden = true
            
        }
    }
    
    func cameraError(camera: LLSimpleCamera?, error: NSError?) {
        print("Camera error:\(error)")
        
        if error?.domain == LLSimpleCameraErrorDomain {
            
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
    }

    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.camera.start()
    }
    
    func panAction(sender:UIPanGestureRecognizer){
        // 判断左移 右移
        if UIGestureRecognizerState.Began == sender.state{
        
            self.startX = self.camera.view.frame.origin.x
            
        }
        
        let detail : CGPoint = sender.translationInView(self.view)
        
        let endX = startX + detail.x
        
        if startX - endX < -100{
            
            self.Action4ChoosePhoto(UIButton)
            
        }else if startX - endX > 100{
            
            self.Action4ChooseVideo(UIButton)
            
        }else{
            //print("Error for pan")
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK:Action 4 Defintion
    func applicationDocumentsDirectory() -> NSURL{

        let urlArray : Array <NSURL> = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentationDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask)
        
        return urlArray.last!
    }
    
    func changeColorForFlashModeButton(){
        
        self.btn4FlashOn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn4FlashOff.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn4FlashAuto.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        if (camera.flash == LLCameraFlashOn){
            self.btn4FlashOn.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }else if (camera.flash == LLCameraFlashOff){
            self.btn4FlashOff.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }else{
            self.btn4FlashAuto.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        }
    }
    
    func changeFlashLightSwitchImage(){
        
        self.shotCutSwitch.hidden = false
        self.btn4FlashAuto.hidden = true
        self.btn4FlashOff.hidden = true
        self.btn4FlashOn.hidden = true
        
        if (camera.flash == LLCameraFlashOn){
            
            self.flashSwitch.setImage(self.img4FalshOn.image, forState: UIControlState.Normal)
            
        }else if (camera.flash == LLCameraFlashOff){
            
            self.flashSwitch.setImage(self.img4FalshOff.image, forState: UIControlState.Normal)
            
        }else{
            
            self.flashSwitch.setImage(self.img4FalshAtuo.image, forState: UIControlState.Normal)
        }
    }
    
    // MARK: Action 4 Button
    @IBAction func ChangeFalshLight(sender: AnyObject) {
        print("打开选择闪光灯")
        
        if(LLSimpleCamera.isRearCameraAvailable()){
            if(self.shotCutSwitch.hidden == false){
                
                self.shotCutSwitch.hidden = true
               // self.flashSwitch.setAttributedTitle(nil, forState: UIControlState.Normal)
                self.btn4FlashAuto.hidden = false
                self.btn4FlashOff.hidden = false
                self.btn4FlashOn.hidden = false
                
                self.changeColorForFlashModeButton()
                
            }else{
                
                self.changeFlashLightSwitchImage()
            }
        }
    }

    @IBAction func chooseFlashMode(sender: AnyObject) {
        
        print("更换闪光灯")
        
        switch (sender.tag - 1000){
        case 0:
            self.camera.updateFlashMode(LLCameraFlashOn)
        case 1:
            self.camera.updateFlashMode(LLCameraFlashOff)
        case 2:
            self.camera.updateFlashMode(LLCameraFlashAuto)
        default:
            print("FlashLight Change Error")
        }
        self.changeFlashLightSwitchImage()

        print("选择了\(self.camera.flash)")
    }
    
    @IBAction func ChangeShot(sender: AnyObject) {
        print("切换摄像头方向")
        self.camera.togglePosition()
    }
    
    @IBAction func BackHome(sender: AnyObject) {
        print("返回主界面")
    }
    
    @IBAction func TakePhotoAndVideo(sender: AnyObject) {
        
        if isPhotoOrVideo {
            print("照相")
            self.camera.capture({ (camera, image, metadata, error) -> Void in
                if (error == nil) {
                    self.camera.start()
                    self.lastImage.setImage(image, forState: UIControlState.Normal)
                    // save this image
                    var data : NSData = UIImagePNGRepresentation(image)!

                }else{
                    print("An error has occured : \(error)")
                }
                }, exactSeenImage: true)
        }else{ //isPhotoOrVideo = false
            
            if self.camera.recording == false {
                print("开始摄像")

                self.shutterPhoto.backgroundColor = UIColor.redColor()
                self.shutterPhoto.layer.masksToBounds = true
                self.shutterPhoto.layer.cornerRadius = shutterPhoto.frame.width / 2
                
                // start recording
                let outputURL : NSURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent("cavyVideo").URLByAppendingPathExtension("mov")
                print("outputURL: \(outputURL)")
                self.camera.startRecordingWithOutputUrl(outputURL)
                
                self.camera.recording = true
            }else{   // stop recording
                
                print("1.停止录像")
                
                self.camera.stopRecording({ (camera, outputURL, error) -> Void in
                    
                    print("2.停止录像")
                })
                self.shutterPhoto.backgroundColor = UIColor.blackColor()
                self.camera.recording = false
            }
        }
    }
    
    @IBAction func GoPhotoAlbum(sender: AnyObject) {
        print("打开相册")
        
        let photoAlbum = PhotoAlbum()
        let nav = UINavigationController(rootViewController: photoAlbum)
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    @IBAction func Action4ChoosePhoto(sender: AnyObject) {
        //print("选择当前为照相")
        self.camera.recording = false
        self.shutterPhoto.backgroundColor = UIColor.blackColor()
        isPhotoOrVideo = true
    //    camera.videoEnabled = false // system dont allow video , close video
        
        self.btn4ChangeToPhoto.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        self.btn4ChangeToVideo.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
    }
    
    @IBAction func Action4ChooseVideo(sender: AnyObject) {
        //print("选择当前为摄影")
      //  camera.videoEnabled = true // system dont allow video , open video
      //  self.camera.recording = true
        isPhotoOrVideo = false
        self.btn4ChangeToPhoto.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.btn4ChangeToVideo.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
    }
    
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
