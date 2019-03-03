//
//  CustomCellForJobList.swift
//  Job Finder
//
//  Created by Deependra Dhakal on 3/3/19.
//  Copyright © 2019 Deependra Dhakal. All rights reserved.
//

import UIKit

class CustomCellForJobList: UITableViewCell {
    
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var jobTitleLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companyLocationLabel: UILabel!
    @IBOutlet weak var jobPostDateLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
