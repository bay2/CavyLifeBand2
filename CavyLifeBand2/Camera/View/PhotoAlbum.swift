//
//  PhotoAlbum.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/1/11.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import AssetsLibrary
import Log
import EZSwiftExtensions
import Photos
import SnapKit

class PhotoAlbum: UIViewController, UIScrollViewDelegate{
    
    var assetResult = [PHAsset]()
    
    var totalCount: Int   = 0
    var currentCount: Int = 0
    var loadIndex: Int    = 0   // 加载到哪的标记
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        scrollView.contentSize = CGSizeMake(ez.screenWidth * CGFloat(self.totalCount), ez.screenHeight - 64 - 49)
        scrollView.contentOffset = CGPoint(x: ez.screenWidth * CGFloat(self.totalCount), y: ez.screenHeight - 64 - 49)
        
        self.loadAssetResult()
        // 解析最新十张图片
        addPhotoes(loadIndex, alReadyLoadCount: currentCount)
        
    }
    
    // 照片库 [PFAsset]
    func loadAssetResult(){
        
        // 使用Photos来获取照片的时候，我们首先需要使用PHAsset和PHFetchOptions来得到PHFetchResult
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        for i in 0  ..< fetchResults.count  {
            
            let asset = fetchResults[i] as! PHAsset 
            
            self.assetResult.append(asset)
        }
        
        self.countLabel.text = "\(self.currentCount)/\(fetchResults.count)"
        
    }
    
    // 从 assetResult 添加图片
    func addPhotoes(needLoadCount: Int, alReadyLoadCount: Int) {
        
        Log.info("加载的是从\(needLoadCount)开始到\(alReadyLoadCount)")
        
        for i in needLoadCount ..< alReadyLoadCount {
            
            let myAsset = self.assetResult[i]
            
            let imageView = UIImageView()
            
            // 返回图片高度
            let scrollHeight = ez.screenHeight - 64 - 49
            
            imageView.frame.size = CGSizeMake(ez.screenWidth, scrollHeight)
            imageView.frame.origin.x = CGFloat(i) * ez.screenWidth
            imageView.contentMode = .ScaleAspectFit
            self.scrollView.addSubview(imageView)
            
            Log.info("\(imageView.frame), \(ez.screenWidth) \(ez.screenHeight)")
            
            // PHImageRequestOptions 设置照片质量
            let imgRequestOptions = PHImageRequestOptions()
            imgRequestOptions.deliveryMode = .HighQualityFormat
            
            // 获取照片
            PHImageManager.defaultManager().requestImageForAsset(myAsset, targetSize: CGSizeMake(ez.screenWidth, ez.screenHeight), contentMode: .AspectFill, options: imgRequestOptions) { (result, info) -> Void in
                
                imageView.image = result
                
            }
        }
        
    }

    // 完成拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        continueLoadPhoto()
        
    }
    
    // 完成拖拽
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        continueLoadPhoto()
        
    }
    
    // 继续加载图片
    func continueLoadPhoto() {
        
        let newCount  = Int(scrollView.contentOffset.x / ez.screenWidth)
        
        self.currentCount = newCount + 1
        self.countLabel.text = "\(self.currentCount)/\(self.totalCount)"
        
        // 到第一张了 就不用加载了
        if self.currentCount == 1 {
            return
        }
        
        // 距离loadIndex 还有三张时候继续往前加载
        if self.currentCount - self.loadIndex < 3{
            
            // 当未加载的照片数目小于10时 从0 ~ loadIndex
            var needLoadIndex = loadIndex - 10
            
            if loadIndex < 10 {
                
                needLoadIndex = 0
            }
                        
            addPhotoes(needLoadIndex, alReadyLoadCount: loadIndex)
            
            loadIndex = needLoadIndex
            
        }
        
    }
    
    @IBAction func action4Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
