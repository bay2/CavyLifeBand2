//
//  UpdateProgressView.swift
//  CavyLifeBand2
//
//  Created by JL on 16/5/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//  固件升级

import UIKit
import EZSwiftExtensions

/// UpdateProgressView(frame: CGRect(x: 0, y: 0, width: UpdateProgressView.viewW, height: UpdateProgressView.viewH))

class UpdateProgressView: UIView {
    
    // MARK: - Property
    
    static let viewW: CGFloat = 270.0
    static let viewH: CGFloat = 108.0
    static let cornerRadius: CGFloat = 12.0
    
    // 标题Label
    var titleLabel: UILabel
    
    // 提示语Label
    var infoLabel: UILabel
    
    // 整个进度条View
    var progressContainerView: UIView
    
    // 白色条View
    var progressAlphaView: UIView
    
    // 绿色条View
    var progressView: UIView
    
    private var progress: Double = 0.0
    
    private static var markView = UIView()
    
    private static let updateProgressView =  UpdateProgressView(frame: CGRect(x: 0, y: 0, width: UpdateProgressView.viewW, height: UpdateProgressView.viewH))
    
    // MARK: - LifeCircle
    deinit {
        Log.info("deinit")
    }
        
    override init(frame: CGRect) {
        
        titleLabel = UILabel()
        
        infoLabel = UILabel()
        
        progressView = UIView()
        
        progressAlphaView = UIView()
        
        progressContainerView = UIView()
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        
        addViews()
        
        layoutViews()
        
        configViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setting
    
    /**
     添加Views
     */
    func addViews() {
        progressAlphaView.addSubview(progressView)
        
        progressContainerView.addSubview(progressAlphaView)
        
        self.addSubview(progressContainerView)
        
        self.addSubview(titleLabel)
        
        self.addSubview(infoLabel)
        
        self.layer.cornerRadius = UpdateProgressView.cornerRadius
    }
    
    /**
     View添加约束
     */
    func layoutViews() {
        progressContainerView.snp_makeConstraints { make in
            make.leading.equalTo(self).offset(20.0)
            make.trailing.equalTo(self).offset(-20.0)
            make.bottom.equalTo(self).offset(-20.0)
            make.height.equalTo(10.0)
        }
        
        progressAlphaView.snp_makeConstraints { make in
            make.leading.equalTo(progressContainerView).offset(2.0)
            make.trailing.equalTo(progressContainerView).offset(-2.0)
            make.top.equalTo(progressContainerView).offset(2.0)
            make.bottom.equalTo(progressContainerView).offset(-2.0)
        }
        
        progressView.snp_makeConstraints { make in
            make.leading.equalTo(progressAlphaView).offset(0.0)
            make.top.equalTo(progressAlphaView).offset(0.0)
            make.bottom.equalTo(progressAlphaView).offset(0.0)
            make.width.equalTo(progressAlphaView.snp_width).multipliedBy(progress)
        }
        
        titleLabel.snp_makeConstraints { make in
            make.leading.equalTo(progressContainerView)
            make.trailing.equalTo(progressContainerView)
            make.top.equalTo(self).offset(20.0)
        }
        
        infoLabel.snp_makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp_bottom).offset(6.0)
        }

    }
    
    /**
     View初始设置（颜色、字体等）
     */
    func configViews() {
        progressContainerView.layer.borderWidth = 1.0
        progressContainerView.layer.borderColor = UIColor(named: .UpdateProgressViewProgressColor).CGColor
        progressContainerView.layer.cornerRadius = 5.0
        
        progressAlphaView.backgroundColor = UIColor.whiteColor()
        progressAlphaView.layer.cornerRadius = 3.0
        
        progressView.backgroundColor = UIColor(named: .UpdateProgressViewProgressColor)
        progressView.layer.cornerRadius = 3.0
        
        titleLabel.textAlignment = .Center
        infoLabel.textAlignment = .Center
        
        titleLabel.font = UIFont.systemFontOfSize(16.0)
        infoLabel.font = UIFont.systemFontOfSize(12.0)
        
        titleLabel.textColor = UIColor(named: .UpdateProgressViewTextColor)
        infoLabel.textColor = UIColor(named: .UpdateProgressViewTextColor)
        
        titleLabel.text = L10n.UpdateProgressTitle.string + (progress * 100).toInt.toString + "%"
        infoLabel.text = L10n.UpdateProgressInfo.string

    }
    
    // MARK: - CallBack
    
    /**
     更新进度条
     */
    func updateProgress(progress: Double, completion: ((progress: Double) -> Void)? = nil) {
        
        if progress > 1.0 {
            self.progress = 1.0
        } else {
            self.progress = progress
        }
        
        titleLabel.text = L10n.UpdateProgressTitle.string + (self.progress * 100).toInt.toString + "%"
        
        progressView.snp_remakeConstraints { make in
            make.leading.equalTo(progressAlphaView).offset(0.0)
            make.top.equalTo(progressAlphaView).offset(0.0)
            make.bottom.equalTo(progressAlphaView).offset(0.0)
            make.width.equalTo(progressAlphaView.snp_width).multipliedBy(self.progress)
        }
        
        UIView.animateWithDuration(0.5, animations: { 
            self.progressAlphaView.layoutIfNeeded()
        }) { [unowned self] result in
            
            completion?(progress: self.progress)
                        
        }
        
    }
    
    /**
     显示
     
     - author: sim cai
     - date: 2016-06-03
     */
    static func show() -> UpdateProgressView {
        
        UpdateProgressView.markView.backgroundColor = UIColor(named: .HomeViewMaskColor)
        
        guard let superView = UIApplication.sharedApplication().keyWindow?.rootViewController?.view else {
            return UpdateProgressView.updateProgressView
        }
        
        superView.addSubview(UpdateProgressView.markView)
        
        
        UpdateProgressView.markView.snp_makeConstraints { make in
            make.top.bottom.left.right.equalTo(superView)
        }
        
        markView.addSubview(UpdateProgressView.updateProgressView)
        UpdateProgressView.updateProgressView.snp_makeConstraints { make in
            make.center.equalTo(markView)
            make.width.equalTo(UpdateProgressView.viewW)
            make.height.equalTo(UpdateProgressView.viewH)
        }
        
        return UpdateProgressView.updateProgressView
        
    }
    
    /**
     隐藏
     
     - author: sim cai
     - date: 2016-06-03
     */
    static func hide() {
        
        UpdateProgressView.markView.removeFromSuperview()
        UpdateProgressView.updateProgressView.updateProgress(0, completion: nil)
        
    }
    
}
