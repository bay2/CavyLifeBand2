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
    
    @IBOutlet weak var btn4FlashOn: UIButton!
    @IBOutlet weak var btn4FlashOff: UIButton!
    @IBOutlet weak var btn4FlashAuto: UIButton!
    @IBOutlet weak var img4FalshAtuo: UIImageView!
    @IBOutlet weak var img4FalshOn: UIImageView!
    @IBOutlet weak var img4FalshOff: UIImageView!
    
    
    @IBOutlet weak var btn4ChangeToPhoto: UIButton!
    @IBOutlet weak var btn4ChangeToVideo: UIButton!
    @IBOutlet weak var shutterPhoto: UIButton!
    @IBOutlet weak var lastImage: UIButton!

    var errorLabel     = UILabel?()
    var camera         = LLSimpleCamera()
    var isPhotoOrVideo = Bool()
    var asset          = [ALAsset]()
    var library        = ALAssetsLibrary()
    var startX         = CGFloat()// panGestureRecognizer start Location
    var countOne       = 0
    
    // MARK: View
    
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
    
    // rewrite block setOnDeviceChange
    func deviceChange(camera: LLSimpleCamera?, device: AVCaptureDevice?) {
        
        Log.info("Device Changed.")
        
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
    
    // MARK:Action 4 Defintion
    func applicationDocumentsDirectory() -> NSURL{
        
        return NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).last!
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

    func getLastPhoto(){


        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group: ALAssetsGroup!, stop) -> Void in
            
            if group != nil
            {
                let assetBlock : ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!, index: Int, stop) in
                    if result != nil
                    {
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

    func startVideo(){
        Log.info("开始摄像")
        
        self.shutterPhoto.backgroundColor = UIColor.redColor()
        self.shutterPhoto.layer.masksToBounds = true
        self.shutterPhoto.layer.cornerRadius = shutterPhoto.frame.width / 2
        // video Name
        let videoName = self.getVideoName()
        
        // start recording
        let outputURL = self.applicationDocumentsDirectory().URLByAppendingPathComponent(videoName).URLByAppendingPathExtension("mov")
        
        Log.info("outputURL: \(outputURL)")
        
        self.camera.startRecordingWithOutputUrl(outputURL)
        
    }
    
    func stopVideo(){
        
        Log.info("1.停止录像")

        self.camera.stopRecording({ (camera, outputFileURL, error) -> Void in
            
            // Viedo in outputURL cache
            
            Log.info("outputFileURL: \(outputFileURL)")

            self.library.writeVideoAtPathToSavedPhotosAlbum(outputFileURL, completionBlock: { (assetUrl, error) -> Void in
                if error != nil {
                    Log.error("Save video fail:%@",error)
                }else {
                    //self.countOne = 0
                    self.getLastPhoto()
                    Log.info("Save video succeed.")
                }
                
            })
            
        })
        self.shutterPhoto.backgroundColor = UIColor.blackColor()
    }
    
    func getVideoName() -> String{
        
        let nowDate :NSDate = NSDate()
        
        let dateForMatter = NSDateFormatter()
        dateForMatter.setLocalizedDateFormatFromTemplate("yyyyMMddHHmmss")
        let videoName : String = dateForMatter.stringFromDate(nowDate)
        
        Log.info("nowDate:\(nowDate)")
        
        return videoName
    }
    
    
    /**
     // 获取图片名字
     - (NSString *)getImgName{
     NSDate *nowDate= [NSDate date]; // 获取当前时间
     NSDateFormatter *dateForMatter = [[NSDateFormatter alloc] init];
     [dateForMatter setDateFormat:@"yyyyMMddHHmmss"];
     NSString *imgName = [dateForMatter stringFromDate:nowDate];
     return imgName;
     }
     
     - parameter sender: <#sender description#>
     */

    // MARK: Action 4 Button
    @IBAction func ChangeFalshLight(sender: AnyObject) {
        Log.info("打开选择闪光灯")
        
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
        
        Log.info("更换闪光灯")
        
        switch (sender.tag - 1000){
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
    
    @IBAction func ChangeShot(sender: AnyObject) {
        Log.info("切换摄像头方向")
        self.camera.togglePosition()
    }
    
    @IBAction func BackHome(sender: AnyObject) {
        Log.info("返回主界面")
    }
    
    @IBAction func TakePhotoAndVideo(sender: AnyObject) {
        
        if isPhotoOrVideo {
            Log.info("照相")
            self.camera.capture({ (camera, image, metadata, error) -> Void in
                if (error == nil) {
                    self.camera.start()
                    self.lastImage.setImage(image, forState: UIControlState.Normal)
                    
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    
                }else{
                    Log.error("An error has occured : \(error)")
                }
                })
        
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
    
    @IBAction func GoPhotoAlbum(sender: AnyObject) {
        Log.info("打开相册")
        
        
        let storyBoard = UIStoryboard(name: "Camera", bundle: nil)
        let photoVC = storyBoard.instantiateViewControllerWithIdentifier("PhotoAlbum")
        
        self .presentViewController(photoVC, animated: true, completion: nil)
        
    }
    
    @IBAction func Action4ChoosePhoto(sender: AnyObject) {
        if self.camera.recording {
            Log.info("直接保存Video")
            self.stopVideo()
        }

        self.shutterPhoto.backgroundColor = UIColor.blackColor()
        isPhotoOrVideo = true
        
        self.btn4ChangeToPhoto.setTitleColor(UIColor.orangeColor(), forState: UIControlState.Normal)
        self.btn4ChangeToVideo.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        
    }
    
    @IBAction func Action4ChooseVideo(sender: AnyObject) {
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
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    

}
