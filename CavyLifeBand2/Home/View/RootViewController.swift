//
//  RootViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class RootViewController: UIViewController, HomeViewDelegate {

    var homeVC: HomeViewController?
    var leftVC: LeftViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leftVC = StoryboardScene.Home.instantiateLeftView()
        homeVC = StoryboardScene.Home.instantiateHomeView()
        
        self.view.addSubview(leftVC!.view)
        self.view.addSubview(homeVC!.view)
        
        homeVC!.homeViewDelegate = self
        
        

        // Do any additional setup after loading the view.
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


        let homeMaskView = UIView(frame: CGRectMake(0, 0, ez.screenWidth, ez.screenHeight))

        homeMaskView.backgroundColor = UIColor.clearColor()

        homeVC!.view.addSubview(homeMaskView)

        UIView.animateWithDuration(0.5) {

            self.homeVC!.view.frame.origin = CGPointMake(ez.screenWidth - (ez.screenWidth / 6), 0)
            homeMaskView.backgroundColor = UIColor(named: .HomeViewMaskColor)

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
