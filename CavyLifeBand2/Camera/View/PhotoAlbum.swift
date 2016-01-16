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

class PhotoAlbum: UIViewController ,UIScrollViewDelegate{
    let screenRect   = UIScreen.mainScreen().bounds
    var asset        = [ALAsset]()
    var library      = ALAssetsLibrary()
    var totalCount:Int   = 0
    var currentCount:Int = 0
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.showCount()

    }

    func showCount(){
        // ALAssetsGroupSavedPhotos

        library.enumerateGroupsWithTypes(ALAssetsGroupSavedPhotos, usingBlock: { (group: ALAssetsGroup!, stop) -> Void in
            
            if group != nil
            {
                let assetBlock : ALAssetsGroupEnumerationResultsBlock = {
                    (result: ALAsset!, index: Int, stop) in
                    if result != nil
                    {
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
        print("viewWillAppear")
        
        
        //        scrollView.backgroundColor = UIColor.redColor()
        scrollView.frame = CGRectMake(0, 64, screenRect.width, screenRect.height - 64 - 69 )
        scrollView.contentSize = CGSizeMake(scrollView.frame.width * CGFloat(self.totalCount), scrollView.frame.height)
        
        scrollView.contentOffset = CGPointMake(scrollView.frame.width * CGFloat(self.currentCount - 1), 0)
        scrollView.pagingEnabled = true
        
        Log.info("totalPage:\(totalCount) ")
        Log.info("currentPage:\(currentCount) ")
        
        for var i = 0 ; i < self.totalCount ; i++ {
            
            
            let bottomView = UIView(frame: CGRectMake(scrollView.frame.width * CGFloat(i), 0, scrollView.frame.width, scrollView.frame.height))
            
            bottomView.backgroundColor = UIColor.clearColor()
            
            let myAsset = self.asset[i]
            let image =  UIImage(CGImage: myAsset.thumbnail().takeUnretainedValue())
            /*
            let newImageView = UIImageView(image: image)
            
            newImageView.contentMode = UIViewContentMode.ScaleAspectFit
            
            newImageView.frame = CGRectMake(0, 0, 200, 100)
            newImageView.center = bottomView.center
            bottomView.addSubview(newImageView)
*/
            
            let tempImageView = ImageForScrollView()

            let newImageView : UIImageView = tempImageView.changeImageSize(image)
            
            newImageView.image = image
            newImageView.backgroundColor = UIColor.cyanColor()
            newImageView.contentMode = UIViewContentMode.ScaleAspectFill
            newImageView.center = bottomView.center
        
            
            bottomView.addSubview(newImageView)
            scrollView.addSubview(bottomView)
        }
        
    }
    
//    scrollViewDidEndDecelerating:
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        let newCount  = Int(scrollView.contentOffset.x / screenRect.width)
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
