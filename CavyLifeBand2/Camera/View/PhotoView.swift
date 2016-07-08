//
//  PhotoView.swift
//  CavyLifeBand2
//
//  Created by Jessica on 16/7/8.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import Foundation

class PhotoView: UIViewController {
    
    @IBOutlet weak var backBtn: NSLayoutConstraint!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
    }
    
    @IBAction func backAction(sender: UIButton) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}