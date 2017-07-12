//
//  PRTableViewCell.swift
//  filediff
//
//  Created by Michael Ferro on 7/10/17.
//  Copyright © 2017 Michael Ferro. All rights reserved.
//

import UIKit

struct PRTableViewModel {
    var title = ""
    var subTitle = ""
}

final class PRTableViewCell: UITableViewCell {

    //MARK: - Private Variables
    
    //MARK: IBOutlets
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var subTitleLable: UILabel!
    
    func configure(_ model : PRTableViewModel) {
        self.titleLabel.text = model.title
        self.subTitleLable.text = model.subTitle
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
