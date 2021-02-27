//
//  HeaderView.swift
//  test2
//
//  Created by Wittawin Muangnoi on 25/2/2564 BE.
//

import UIKit

protocol HeaderViewDelegate {
    func headerViewDidSelect(section: Int)
}

class HeaderView: UIView{
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
         Drawing code
    }
    */
    var label = UILabel()
    private var imageView = UIImageView()
    private var disclosure = UIImageView()
    private var tapRecognizer = UITapGestureRecognizer()
    private var section : Int!
    var delegate : HeaderViewDelegate?
    var title : String!
    
    
    
    init(title: String, section : Int, showDisclosure : Bool = true) {
        self.title = title
        self.section = section
        super.init(frame: CGRect())
        tapRecognizer.addTarget(self, action: #selector(onTap))
        addGestureRecognizer(tapRecognizer)
        initView(showDisclosure: showDisclosure)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    @objc func onTap() {
        delegate?.headerViewDidSelect(section: self.section)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initView(showDisclosure : Bool) {
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        disclosure.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 27)
        imageView.image = UIImage(systemName: "")
        disclosure.image = UIImage(systemName: "chevron.right")
        addSubview(label)
        addSubview(disclosure)
        disclosure.isHidden = !showDisclosure
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor,constant: 0),
            label.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            label.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
            disclosure.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            disclosure.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
        
}
