//
//  PKRecordsTableViewCell.swift
//  CavyLifeBand2
//
//  Created by JL on 16/4/28.
//  Copyright © 2016年 xuemincai. All rights reserved.
//

import UIKit

class PKRecordsTableViewCell: UITableViewCell {
    
    var cellViewModel: PKRecordsCellDataSource?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(viewModel: PKRecordsCellDataSource) -> Void {
        self.cellViewModel = viewModel
    }
    
    @IBAction func clickBtn(sender: UIButton) {
        
        self.cellViewModel?.clickBtn()
        
    }
    
}
