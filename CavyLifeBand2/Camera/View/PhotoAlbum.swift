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

class PhotoAlbum: UIViewController, UIScrollViewDelegate{
    
    var assetResult = [PHAsset]()
    
    var totalCount: Int   = 0
    var currentCount: Int = 0
    var loadIndex: Int    = 0   // 加载到哪的标记
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.showCount()
        
    }
    
    // 照片数量
    func showCount(){

        // 使用Photos来获取照片的时候，我们首先需要使用PHAsset和PHFetchOptions来得到PHFetchResult
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        let fetchResults = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        self.totalCount = fetchResults.count
        self.currentCount = fetchResults.count
        self.loadIndex = fetchResults.count - 10
        
        for var i = 0 ; i < fetchResults.count ; i++ {
            
            let asset = fetchResults[i] as! PHAsset
            
            self.assetResult.append(asset)
        }

        self.countLabel.text = "\(self.currentCount)/\(fetchResults.count)"
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // add scrollView
        scrollView.contentSize = CGSizeMake(ez.screenWidth * CGFloat(self.totalCount), scrollView.frame.height)
        scrollView.contentOffset = CGPoint(x: ez.screenWidth * CGFloat(self.totalCount), y: scrollView.frame.height)
        
        Log.info("totalPage:\(totalCount) ")
        Log.info("currentPage:\(currentCount) ")
        
        // 解析最新十张图片
        addPhotoes(loadIndex, alReadyLoadCount: currentCount)
    }
    
    // 从 assetResult 添加图片
    func addPhotoes(needLoadCount: Int, alReadyLoadCount: Int) {
        
        print("加载的是从\(needLoadCount)开始到\(alReadyLoadCount)")
            
            for var i = needLoadCount; i < alReadyLoadCount; i++ {
                
                let myAsset = self.assetResult[i]
                
                let imageView = UIImageView()
                
                imageView.frame.size = CGSizeMake(ez.screenWidth, self.scrollView.size.height)
                imageView.frame.origin.x = CGFloat(i) * ez.screenWidth
                imageView.contentMode = .ScaleAspectFit
                self.scrollView.addSubview(imageView)
                
                Log.info("\(imageView.frame), \(ez.screenWidth) \(ez.screenHeight)")
                
                
                let imgRequestOptions = PHImageRequestOptions()
                imgRequestOptions.deliveryMode = .HighQualityFormat

                PHImageManager.defaultManager().requestImageForAsset(myAsset, targetSize: CGSizeMake(ez.screenWidth, ez.screenHeight), contentMode: .AspectFill, options: imgRequestOptions) { (result, info) -> Void in
                    
                    imageView.image = result
                    
                }
                
                view.addSubview(bottomView)
                
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
