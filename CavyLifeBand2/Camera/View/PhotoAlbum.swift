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

class PhotoAlbum: UIViewController, UIScrollViewDelegate{
    
    var asset        = [ALAsset]()
    var library      = ALAssetsLibrary()
    var totalCount: Int   = 0
    var currentCount: Int = 0
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        self.showCount()

    }
    
    // show photoAlbum total count
    func showCount(){
        
        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group: ALAssetsGroup!, stop) -> Void in
            if group != nil{
                
                let assetBlock: ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!, index: Int, stop) in
                    
                    if result != nil{
                        self.asset.append(result)
                        self.totalCount++
                    }
                }
                
                group.enumerateAssetsUsingBlock(assetBlock)
                
                self.currentCount = self.totalCount
                
                Log.info("assets:\(self.totalCount)")
                
                self.countLabel.text = "\(self.currentCount)/\(self.totalCount)"
            }
            }) { (error) -> Void in
                
                Log.error("Error:\(error)")
        }
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // add scrollView
        scrollView.contentSize = CGSizeMake(ez.screenWidth * CGFloat(self.totalCount), scrollView.frame.height)
        scrollView.contentOffset = CGPoint(x: ez.screenWidth * CGFloat(self.totalCount), y: scrollView.frame.height)
        
        Log.info("totalPage:\(totalCount) ")
        Log.info("currentPage:\(currentCount) ")
        
        // add all photo
        for var i = 0 ; i < self.totalCount ; i++ {
            
            let myAsset = self.asset[i]
            
            let imageView = UIImageView(image: UIImage(CGImage: myAsset.defaultRepresentation().fullResolutionImage().takeUnretainedValue()))
            
            imageView.frame.size = CGSizeMake(ez.screenWidth, scrollView.size.height)
            imageView.frame.origin.x = CGFloat(i) * ez.screenWidth
            imageView.contentMode = .ScaleAspectFit
            
            Log.info("\(imageView.frame), \(ez.screenWidth) \(ez.screenHeight)")

            scrollView.addSubview(imageView)
        }
    }
    
    // change current photo will change
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let newCount  = Int(scrollView.contentOffset.x / ez.screenWidth)
        Log.info("计算后的当前页：\(newCount)")

        self.currentCount = newCount + 1
        self.countLabel.text = "\(self.currentCount)/\(self.totalCount)"
    }
    
    @IBAction func action4Back(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
