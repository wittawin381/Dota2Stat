//
//  MyHeoresTableViewCell.swift
//  test2
//
//  Created by Wittawin Muangnoi on 15/2/2564 BE.
//

import UIKit

class MyHeoresTableViewCell: UITableViewCell {

    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var heroName: UILabel!
    @IBOutlet weak var matchPlayed: UILabel!
    @IBOutlet weak var matchPlayProg: UIProgressView!
    @IBOutlet weak var winrate: UILabel!
    @IBOutlet weak var winrateProg: UIProgressView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        heroImg.image = UIImage(named: "abaddon_full")
        heroImg.contentMode = .scaleAspectFill
        heroImg.layer.cornerRadius = heroImg.frame.size.width / 2
        heroImg.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
