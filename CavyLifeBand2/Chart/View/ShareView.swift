//
//  ShareView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/5/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

// height：40 + 24 + 60 + 24 = 148
class ShareView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var bottomView = UIView()
    var collectionView: UICollectionView?
    
    let shareDataArray: [ShareViewDataSource] = [ShareWechatViewModel(), ShareWechatMomentsViewModel(),
                                                 ShareQQViewModel(), ShareWeiboViewModel()]
    
    var publishContent: ISSContent = ShareSDK.content(L10n.ShareContent.string,
                                                       defaultContent: L10n.ShareTitle.string,
                                                       image: ShareSDK.jpegImageWithImage(UIImage(named: "banner_home"), quality: 1.0),
                                                       title: L10n.ShareTitle.string,
                                                       url: "http://www.tunshu.com",
                                                       description: L10n.ShareContent.string,
                                                       mediaType: SSPublishContentMediaTypeImage)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor(gray: 1, alpha: 0.4)
        let backView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight - 148))
        backView.backgroundColor = UIColor.clearColor()
        backView.addTapGesture { [unowned self] pan in
            self.removeFromSuperview()
        }
        self.addSubview(backView)

        bottomView.backgroundColor = UIColor.whiteColor()
        bottomView.frame = CGRectMake(0, ez.screenHeight, ez.screenWidth, 148)
        self.addSubview(bottomView)
        
        let titleView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, 40))
        titleView.backgroundColor = UIColor(named: .HomeViewMainColor)
        let titleLabel = UILabel(frame: CGRectMake(0, 0, ez.screenWidth, 40))
        titleLabel.text = L10n.ShareTo.string
        titleLabel.textAlignment = .Center
        titleLabel.textColor = UIColor.whiteColor()
        titleView.addSubview(titleLabel)
        bottomView.addSubview(titleView)

        addCollectionView()
        
        self.animate(duration: 0.2, animations: {
            self.bottomView.frame = CGRectMake(0, ez.screenHeight - 148, ez.screenWidth, 148)
        })
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Log.info("deinit")
    }
    
    /**
     添加CollectionView
     */
    func addCollectionView() {
        
        let inset: CGFloat = 16
        let sizeWidth: CGFloat = 60
        let space = (ez.screenWidth - inset * 2 - sizeWidth * 4) / 3
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(sizeWidth, sizeWidth)
        layout.scrollDirection = .Horizontal
        layout.minimumLineSpacing = space
        
        layout.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset)
        
        collectionView = UICollectionView(frame: CGRectMake(0, 64, (ez.screenWidth), 60), collectionViewLayout: layout)
        collectionView!.contentSize = CGSizeMake(ez.screenWidth * 2, 60)
        collectionView!.contentOffset = CGPointMake(0, 60)
        collectionView!.backgroundColor = UIColor.whiteColor()
        collectionView!.showsHorizontalScrollIndicator = false
        collectionView!.alwaysBounceHorizontal = true
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(ShareCollectionCell.self, forCellWithReuseIdentifier: "ShareCellIdentifier")

        bottomView.addSubview(collectionView!)

    }
    
    
    // MARK: -- collectionView Delegate
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return shareDataArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ShareCellIdentifier", forIndexPath: indexPath) as! ShareCollectionCell
        
        cell.imgView.image = shareDataArray[indexPath.item].shareImage
        
        return cell
    }
    
    // 点击事件
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        Log.info("点我分享啊\(indexPath.item)")
        
        share(shareDataArray[indexPath.item].type)
        
        self.removeFromSuperview()
    
    }
    
    // 可以点击
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        return true
        
    }
    
    /**
     分享
     
     - parameter type: 分享的平台类型
     */
    func share(type: ShareType) {
        
        let urls = NSSearchPathForDirectoriesInDomains(.CachesDirectory, .UserDomainMask, true)
        
        var savePath = urls[0]
        
        let imageFullName = CavyDefine.shareImageName.stringByAppendingString(".png")
        
        savePath = savePath + "/" + imageFullName
        
        publishContent.setImage(ShareSDK.imageWithPath(savePath))
        
        
        ShareSDK.clientShareContent(publishContent, type: type, statusBarTips: true, result: { (shareType, state, platformShareInfo, error, end) in
            switch state{
                
            case SSResponseStateSuccess:
                Log.info("分享成功")
                let alert = UIAlertView(title: "分享成功", message: "分享成功", delegate: self, cancelButtonTitle: "确定")
                alert.show()
            case SSResponseStateFail:
                Log.error("分享失败,错误描述:\(error)")
            case SSResponseStateCancel:
                Log.info("分享取消")
                
            default:
                break
            }
        })

    }
    
}
