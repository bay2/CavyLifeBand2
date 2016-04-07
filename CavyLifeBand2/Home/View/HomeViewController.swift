//
//  HomeViewController.swift
//  CavyLifeBand2
//
//  Created by xuemincai on 16/3/16.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit
import Log
import EZSwiftExtensions

class HomeViewController: UIViewController {


    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HomeViewController.pushNextView), name: NotificationName.HomeLeftOnClickCellPushView.rawValue, object: nil)

        // navigationController?
        self.navigationController?.navigationBar.tintColor  = UIColor(named: .HomeViewMainColor)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "backbtn"), style: .Plain, target: self, action: #selector(showLeftView))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "backbtn"), style: .Plain, target: self, action: #selector(showLeftView))
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showLeftView() {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }

    @IBAction func test(sender: AnyObject) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(NotificationName.HomeLeftOnClickMenu.rawValue, object: nil)
        
    }
    
    func pushNextView(userInfo: NSNotification) {

        guard let viewController = userInfo.userInfo?["nextView"] as? UIViewController else {
            return
        }
        
        self.navigationController?.pushViewController(viewController, animated: false)
        
    }

}
