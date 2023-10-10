//
//  SubscriptionInfoTableViewCell.swift
//  Hows-ing
//
//  Created by 황재상 on 10/10/23.
//

import UIKit
import SafariServices

class SubscriptionInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var AddrLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
