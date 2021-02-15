//
//  FixtureTableViewCell.swift
//  test2
//
//  Created by Wittawin Muangnoi on 13/2/2564 BE.
//

import UIKit

class FixtureTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var gameMode: UILabel!
    @IBOutlet weak var bracket: UILabel!
    @IBOutlet weak var kda: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        heroImg.image = UIImage(named: "abaddon_full")
        heroImg.contentMode = .scaleAspectFill
        heroImg.layer.cornerRadius = heroImg.frame.size.width / 2
        heroImg.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
