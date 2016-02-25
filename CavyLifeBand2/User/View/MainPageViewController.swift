//
//  MainPageViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/2/24.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var pageImage = [UIImage(asset: .PageImage1), UIImage(asset: .PageImage1), UIImage(asset: .PageImage1), UIImage(asset: .PageImage1)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        guard let pageView = viewControllerAtIndex(0) else {
            return
        }
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        setViewControllers([pageView], direction: .Forward, animated: true, completion: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     返回当前视图的前一个视图
     
     - parameter pageViewController:
     - parameter viewController:
     
     - returns: 视图
     */
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = (viewController as! PageViewController).pageIndex - 1
        
        return viewControllerAtIndex(pageIndex)
    }
    
    /**
     返回当前视图的后一个视图
     
     - parameter pageViewController:
     - parameter viewController:
     
     - returns: 视图
     */
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let pageIndex = (viewController as! PageViewController).pageIndex + 1
        
        return viewControllerAtIndex(pageIndex)
    }
    
    /**
     根据索引创建视图
     
     - parameter index: 索引
     
     - returns: 视图
     */
    func viewControllerAtIndex(index: Int) -> PageViewController? {
        
        if index < 0 || index >= pageImage.count {
            return nil
        }
        
        let pageVC = StoryboardScene.Main.MainPageView.viewController() as! PageViewController
        
        if index == pageImage.count - 1 {
            pageVC.isLastPage = true
        }
        
        pageVC.pageIndex = index
        pageVC.backgroundImage = pageImage[index]
        
        return pageVC
        
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
