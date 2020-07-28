//
//  MyContactCell.swift
//  DN-Wallet
//
//  Created by Ahmed Eid on 3/17/20.
//  Copyright © 2020 DN. All rights reserved.
//

import UIKit

class MyContactCell: UITableViewCell {

    static var reuseIdentifier = "my-contact-cell-identifier"
    let avatarImage            = DNAvatarImageView(frame: .zero)
    let usernameTitleLabel     = DNTitleLabel(textAlignment: .left, fontSize: 24)
    let emailTitleLabel        = DNSecondaryTitleLabel(fontSize: 14)
    
    var data: Contact? {
        didSet {
            guard let data = data else {return}
            contactUsername.text = data.userID.name
            contactEmail.text = data.userID.email
            avatarImage.downlaodedImage(from: "jk")
        }
    }
    
    var contactUsername: UILabel = {
        let lb = UILabel()
        lb.text = "Contact 1"
        lb.textColor = .DnDarkBlue
        lb.font = UIFont.DN.Regular.font(size: 18)
        return lb
    }()
    
    var contactEmail: UILabel = {
        let lb = UILabel()
        lb.text = "Contact1@gmail.com"
        lb.textColor = .DnDarkBlue
        lb.font = UIFont.DN.Regular.font(size: 16)
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .DnCellColor
        self.accessoryType = .disclosureIndicator
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        let Vstack = UIStackView(arrangedSubviews: [contactUsername, contactEmail])
        Vstack.configureStack(axis: .vertical, distribution: .fillEqually, alignment: .fill, space: 8)
        
        addSubview(avatarImage)
        addSubview(Vstack)
        
        avatarImage.DNLayoutConstraint(left: contentView.leftAnchor, margins: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        avatarImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        Vstack.DNLayoutConstraint(contentView.topAnchor, left: avatarImage.rightAnchor, right: contentView.rightAnchor, bottom: contentView.bottomAnchor, margins: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
}

