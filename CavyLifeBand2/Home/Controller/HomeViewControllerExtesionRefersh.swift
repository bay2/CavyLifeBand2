//
//  HomeViewControllerExtesionRefersh.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/6/29.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation
import Log
import JSONJoy
import SnapKit
import EZSwiftExtensions
import RealmSwift
import MJRefresh

enum RefreshStatus: String {
    
    case AddAutoRefresh
    case StopRefresh
    
}



extension HomeViewController {
    
    /**  开始刷新
     *   打开APP 开始刷新 （ addAutoRefreshHeader ）
     *   后台进入前台（ addPullRefreshHeader ）
     */
    func beginHomeViewRefreshing() {
        
        addAutoRefreshHeader()
        
        scrollView.mj_header.beginRefreshing()
        
    }
    
    
    /**
     添加自动刷新（打开APP）
     */
    func addAutoRefreshHeader() {
        
        // 打开APP 开始刷新 （ addAutoRefreshHeader ） 后台进入前台（ addPullRefreshHeader ）
        
        let onlyShowHeader = MJRefreshHeader(refreshingBlock: {
            
            // 如果没有打开蓝牙
            if LifeBandBle.shareInterface.centraManager?.state != .PoweredOn {
              
                self.endHomeViewRefreshing()
                
                return
            }
            
            // 如果没有连接手环
            if LifeBandBle.shareInterface.getConnectState() != .Connected {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                    // AlertView 提醒没有绑定手环
                    self.addAlertView()
                    // 停止刷新
                    self.endHomeViewRefreshing()
                    
                }
                return
            }
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                    
                    self.endHomeViewRefreshing()
            }
            
        })
        
        onlyShowHeader.backgroundColor = UIColor(named: .HomeViewMainColor)
        scrollView.mj_header = onlyShowHeader
        
    }
    
    /**
     添加下拉刷新
     */
    func addPullRefreshHeader() {
        
        // 打开APP 开始刷新 （ addAutoRefreshHeader ） 后台进入前台（ addPullRefreshHeader ）
        let header = MJRefreshHeader(refreshingBlock: {
            
            
            // 如果没有连接手环
            if LifeBandBle.shareInterface.getConnectState() != .Connected {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                    // AlertView 提醒没有绑定手环
                    self.addAlertView()
                    // 停止刷新
                    self.endHomeViewRefreshing()
                    
                }
                
            } else {
            
                //MARK: 手动刷新
                RootViewController().syncDataFormBand(false)
                
                var daleyTime = 15
                
                let lastTime = self.queryAllStepInfo(self.userId).last?.time ?? NSDate()
                
                if lastTime.toString(format: "yyyy-MM-dd") == NSDate().toString(format: "yyyy-MM-dd") {
                    daleyTime = 5
                }
                
                if lastTime.toString(format: "yyyy-MM-dd HH") == NSDate().toString(format: "yyyy-MM-dd HH") {
                    daleyTime = 3
                }
                
                if lastTime.toString(format: "yyyy-MM-dd HH:mm") == NSDate().toString(format: "yyyy-MM-dd HH:mm") {
                    daleyTime = 1
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(UInt64(daleyTime)
                    * NSEC_PER_SEC)), dispatch_get_main_queue ()) {
                        
                        self.endHomeViewRefreshing()
                }
            
            }
        })
        
        header.backgroundColor = UIColor(named: .HomeViewMainColor)
        scrollView.mj_header = header
        
    }
    
    /**
     停止刷新 并添加
     */
    func endHomeViewRefreshing() {
        
        scrollView.mj_header.endRefreshing()
        addPullRefreshHeader()
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
            
            // 添加活动指示器旋转
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
            scrollView.mj_header.addSubview(activityView)
            activityView.snp_makeConstraints{ make in
                make.centerX.equalTo(0).offset(-40)
                make.size.equalTo(CGSizeMake(20, 20))
                make.centerY.equalTo(0)
            }
            // 添加文字
            activityView.startAnimating()
            
            label.snp_remakeConstraints{ make in
                make.left.equalTo(activityView.snp_right)
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

