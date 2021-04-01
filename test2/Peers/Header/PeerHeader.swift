//
//  PeerHeader.swift
//  test2
//
//  Created by Wittawin Muangnoi on 16/3/2564 BE.
//

import Foundation
import UIKit

class PeerHeader : UIView {
    
    init() {
        super.init(frame: CGRect())
        initView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initView()
    }
    
    func category(title : String) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 10)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        return view
    }
    
    func initView() {
        let playWith = category(title: "Played With")
        let winWith = category(title: "Win With")
        playWith.translatesAutoresizingMaskIntoConstraints = false
        winWith.translatesAutoresizingMaskIntoConstraints = false
        addSubview(playWith)
        addSubview(winWith)
        NSLayoutConstraint.activate([
            winWith.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            winWith.topAnchor.constraint(equalTo: topAnchor),
            winWith.bottomAnchor.constraint(equalTo: bottomAnchor),
            winWith.widthAnchor.constraint(equalToConstant: 60),
            playWith.rightAnchor.constraint(equalTo: winWith.leftAnchor, constant: -10),
            playWith.topAnchor.constraint(equalTo: topAnchor),
            playWith.bottomAnchor.constraint(equalTo: bottomAnchor),
            playWith.widthAnchor.constraint(equalToConstant: 60),
        ])
    }
}
