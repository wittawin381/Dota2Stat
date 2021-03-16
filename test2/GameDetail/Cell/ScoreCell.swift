//
//  ScoreCell.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import UIKit

class ScoreCell: UITableViewCell {

    @IBOutlet var direScore: UILabel!
    @IBOutlet var radiantScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
