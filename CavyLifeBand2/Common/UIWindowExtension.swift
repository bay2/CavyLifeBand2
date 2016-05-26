//
//  UIWindowExtension.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/4/19.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

extension UIWindow {
    
    func setRootViewController(newRootViewController: UIViewController, transition: CATransition? = nil) {
    
        let previousViewController = rootViewController
        
        for subView in previousViewController!.view.subviews {
            subView.removeFromSuperview()
        }
        
        previousViewController?.view.removeFromSuperview()
    
        if let transition = transition {
            // Add the transition
            layer.addAnimation(transition, forKey: kCATransition)
        }
        
        rootViewController = newRootViewController
        
        // Update status bar appearance using the new view controllers appearance - animate if needed
        if UIView.areAnimationsEnabled() {
            UIView.animateWithDuration(CATransaction.animationDuration()) {
                newRootViewController.setNeedsStatusBarAppearanceUpdate()
            }
        } else {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        }
        
        /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
        if let transitionViewClass = NSClassFromString("UITransitionView") {
            for subview in subviews where subview.isKindOfClass(transitionViewClass) {
                subview.removeFromSuperview()
            }
        }
        
        if let previousViewController = previousViewController {
            // Allow the view controller to be deallocated
            previousViewController.dismissViewControllerAnimated(false) {
                // Remove the root view in case its still showing
                previousViewController.view.removeFromSuperview()
            }
        }
    }
    
}

