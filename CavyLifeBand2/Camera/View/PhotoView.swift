//
//  PhotoView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import AssetsLibrary
import Log
import EZSwiftExtensions
import Photos
import SnapKit

let bottomHeight: CGFloat = 49
let headerHeight: CGFloat = 64

class PhotoView: UIViewController {
    
    var assetResult = [PHAsset]()
    
    var totalCount: Int   = 0
    var currentCount: Int = 0
        
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    
    var collectionView: UICollectionView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton.setTitle(L10n.CameraBack.string, forState: .Normal)
        
        loadAssetResult()
        addCollectionView()
        
        
    }
    
    /**
     添加相册视图
     */
    func addCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(ez.screenWidth, ez.screenHeight - headerHeight - bottomHeight)
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = 0

        collectionView = UICollectionView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight - headerHeight), collectionViewLayout: layout)
        
        collectionView!.contentSize = CGSizeMake(ez.screenWidth * CGFloat(self.totalCount), ez.screenHeight - headerHeight - bottomHeight)
        collectionView!.contentOffset = CGPoint(x: ez.screenWidth * CGFloat(self.totalCount), y: ez.screenHeight - headerHeight - bottomHeight)
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.registerClass(ImageViewCell.self, forCellWithReuseIdentifier: "ImageViewCell")
        collectionView!.delegate = self
        collectionView!.dataSource = self
        collectionView!.pagingEnabled = true
        self.view.addSubview(collectionView!)
        collectionView!.snp_makeConstraints { make in
            make.left.right.equalTo(self.view)
            make.size.equalTo(CGSizeMake(ez.screenWidth, ez.screenHeight - headerHeight - bottomHeight))
            make.center.equalTo(self.view)
        }
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
    

    @IBAction func backAction(sender: UIButton) {
        
        self.totalCount = 0
        self.currentCount = 0
        self.assetResult = []
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension PhotoView: UICollectionViewDelegate, UICollectionViewDataSource {
  
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return totalCount
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageViewCell", forIndexPath: indexPath) as! ImageViewCell

        cell.configImage(assetResult[indexPath.item])
        
        return cell
        
    }
    
}

extension PhotoView: UIScrollViewDelegate {
    
    // 完成拖拽
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        currentCount = Int(scrollView.contentOffset.x / ez.screenWidth)
        
        self.countLabel.text = "\(self.currentCount + 1)/\(self.totalCount)"

    }
    
}
