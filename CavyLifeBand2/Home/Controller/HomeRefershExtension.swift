//
//  HomeRefershExtension.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/18.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Foundation
import Log
import JSONJoy
import SnapKit
import EZSwiftExtensions
import RealmSwift
import MJRefresh
import Gifu

enum RefreshStyle: String {
    
    case BeginRefresh
    case StopRefresh
    
}

extension HomeViewController {
    
    
    func beginBandRefersh(){
        
       if scrollView.mj_header.state == .Refreshing {
            
            return
            
        }
        
        scrollView.mj_header.beginRefreshing()

        
    }
    
    func endBandRefersh() {
        
        if scrollView.mj_header.state != .Refreshing {
            
            return
        }
        
        // 没有打开蓝牙 || 没有连接手环
        if LifeBandBle.shareInterface.centraManager?.state != .PoweredOn || LifeBandBle.shareInterface.getConnectState() != .Connected {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                // 同步数据失败
                self.addAlertView()
                // 停止刷新
                self.scrollView.mj_header.endRefreshing()
                
            }

            return
        }
        
        self.scrollView.mj_header.endRefreshing()

    }
    
    func addRefershHeader() {
        
        let header = MJRefreshHeader(refreshingBlock: {
            
            // 没有打开蓝牙 || 没有连接手环
            if LifeBandBle.shareInterface.centraManager?.state != .PoweredOn || LifeBandBle.shareInterface.getConnectState() != .Connected {
                
                self.endBandRefersh()
            }
            
            // 打开蓝牙并且连接手环
            if LifeBandBle.shareInterface.centraManager?.state == .PoweredOn && (LifeBandBle.shareInterface.getConnectState() == .Connected || LifeBandBle.shareInterface.getConnectState() == .Connecting) {
                
                RootViewController().syncDataFormBand()
              
                return
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(2) * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                
                // 停止刷新
                self.endBandRefersh()
                
            }
        })
        
        header.backgroundColor = UIColor(named: .HomeViewMainColor)
        scrollView.mj_header = header

    }
    
/**
      未连接手环的弹窗
      */
    func addAlertView() {


        let alertView = UIAlertController(title: L10n.HomeRefreshAlertTitle.string, message: L10n.HomeRefreshFaildDes.string, preferredStyle: .Alert)

        let sureAction = UIAlertAction(title: L10n.AlertSureActionTitle.string, style: .Cancel, handler: nil)
        let subInfoView = alertView.view.subviews[0].subviews[0].subviews[0].subviews[0].subviews[0]

        let message: UILabel = subInfoView.subviews[1] as? UILabel ?? UILabel()
        message.textAlignment = .Left

        alertView.addAction(sureAction)

        self.presentViewController(alertView, animated: true, completion: nil)

    }

}

// MARK: UIScrollViewDelegate

var oldOffSet: CGFloat = 0

extension HomeViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(scrollView: UIScrollView) {

        // 禁止上拉
        if scrollView.contentOffset.y > 0 {

            scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
            return
        }

        // head 最高60
        if scrollView.contentOffset.y < -60 {

            scrollView.setContentOffset(CGPointMake(0, -60), animated: false)
            return
        }

        // 判断 下滑时候
        scrollView.mj_header.removeSubviews()
        let label = UILabel()
        scrollView.mj_header.addSubview(label)
        label.snp_makeConstraints { make in
            make.center.equalTo(0)
            make.size.equalTo(CGSizeMake(ez.screenWidth, 20))
        }
        label.text = ""
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center

        if scrollView.mj_header.state == MJRefreshState.Idle {

            label.text = L10n.HomeRefreshIdle.string

        }

        if scrollView.mj_header.state == MJRefreshState.Pulling {

            label.text = L10n.HomeRefreshPulling.string

        }

        if scrollView.mj_header.state == MJRefreshState.Refreshing {
            
            let imgView = AnimatableImageView()
            imgView.animateWithImage(named: "loading@3x.gif")

            scrollView.mj_header.addSubview(imgView)
            imgView.snp_makeConstraints{ make in
                make.centerX.equalTo(0).offset(-70)
                make.size.equalTo(CGSizeMake(50, 50))
                make.centerY.equalTo(0)
            }
          
            label.snp_remakeConstraints{ make in
                make.left.equalTo(imgView.snp_right)
                make.centerY.equalTo(0)
            }
            label.text = L10n.HomeRefreshRefreshing.string

        }

        if scrollView.mj_header.state == MJRefreshState.NoMoreData{
            // 结束刷新
            label.text = ""
            scrollView.mj_header.endRefreshing()

        }

    }

}


