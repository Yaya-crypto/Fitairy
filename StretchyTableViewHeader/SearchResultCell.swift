//
//  SearchResultCell.swift
//  StretchyTableViewHeader
//
//  Created by Ahmed, Yehya on 11/26/22.
//

import UIKit

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var foodname: UILabel!
    @IBOutlet weak var foodMacros: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor().hexStringToUIColor(hex: "ADD8E6")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
