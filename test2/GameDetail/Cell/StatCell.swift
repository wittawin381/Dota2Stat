//
//  StatCell.swift
//  test2
//
//  Created by Wittawin Muangnoi on 26/2/2564 BE.
//

import Foundation
import UIKit

class StatCell : UITableViewCell {
    
    
    @IBOutlet weak var heroImg: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var kda: UILabel!
    
    
    @IBOutlet var itemsImg: [UIImageView]!
    //    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        heroImg
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        heroImg.contentMode = .scaleAspectFill
        heroImg.layer.cornerRadius = 10
        
    }
    
    
}
