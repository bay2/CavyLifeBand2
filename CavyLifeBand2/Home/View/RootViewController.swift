//
//  RootViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class RootViewController: UIViewController  {

    var homeVC: UINavigationController?
    var leftVC: LeftViewController?
    let homeMaskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        leftVC = StoryboardScene.Home.instantiateLeftView()
        homeVC = UINavigationController(rootViewController: StoryboardScene.Home.instantiateHomeView())

        self.view.addSubview(leftVC!.view)
        self.view.addSubview(homeVC!.view)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.onClickMenu), name: NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(RootViewController.hiddenLeftView), name: NotificationName.HomeLeftHiddenMenu.rawValue, object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     点击菜单按钮
     */
    func onClickMenu() {

        showLeftView()

    }

    /**
     显示左侧列表视图
     */
    func showLeftView() {


        homeMaskView.backgroundColor = UIColor.clearColor()

        homeMaskView.addTapGesture { _ in

            self.hiddenLeftView()

        }

        homeVC!.view.addSubview(homeMaskView)

        UIView.animateWithDuration(0.5) {

            self.homeVC!.view.frame.origin = CGPointMake(ez.screenWidth - (ez.screenWidth / 6), 0)
            self.homeMaskView.backgroundColor = UIColor(named: .HomeViewMaskColor)

        }

    }

    func hiddenLeftView() {

        UIView.animateWithDuration(0.5) {

            self.homeVC!.view.frame.origin = CGPointMake(0, 0)
            self.homeMaskView.backgroundColor = UIColor.clearColor()
            self.homeMaskView.removeFromSuperview()

        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
